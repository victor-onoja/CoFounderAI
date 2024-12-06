import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../models/project.dart';
import '../../models/sprint.dart';
import '../../models/task.dart';
import 'project_state.dart';

class ProjectBloc extends Cubit<ProjectState> {
  static const apikey = "AIzaSyD_oL-0jXjJ3qgQsJ7lzah-fs6p5j2PMtE";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GenerativeModel _model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apikey);
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  ProjectBloc() : super(ProjectInitial());

  Future<void> convertToProject(String expandedIdea) async {
    emit(ProjectLoading());
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final prompt = '''
      Convert the following expanded idea into a project plan with weekly sprints:
        $expandedIdea
        
        Format the response as JSON with the following structure:
        {
          "title": "Project Title",
          "description": "Brief project description",
          "sprints": [
            {
              "title": "Sprint Title",
              "description": "Sprint description",
              "tasks": [
                {
                  "title": "Task Title",
                  "description": "Task description"
                }
              ],
              "dueDate": "YYYY-MM-DD"
            }
          ]
        }
       ''';
      final response = await _model.generateContent([Content.text(prompt)]);
      // final projectData = json.decode(response.text!);
      String jsonString = response.text!.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      jsonString = jsonString.trim();

      final projectData = json.decode(jsonString);

      final project = Project(
        id: _firestore.collection('projects').doc().id,
        title: projectData['title'],
        description: projectData['description'],
        sprints: (projectData['sprints'] as List)
            .map((s) => Sprint(
                  id: _firestore.collection('sprints').doc().id,
                  title: s['title'],
                  description: s['description'],
                  tasks: (s['tasks'] as List)
                      .map((t) => Task(
                            id: _firestore.collection('tasks').doc().id,
                            title: t['title'],
                            description: t['description'],
                          ))
                      .toList(),
                  dueDate: DateTime.parse(s['dueDate']),
                ))
            .toList(),
        startDate: DateTime.now(),
        userId: currentUser.uid,
      );

      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toJson());
      emit(ProjectLoaded(project));
    } catch (e) {
      emit(ProjectError('Failed to convert idea to project: ${e.toString()}'));
    }
  }

  Future<void> updateProjectProgress(Project project) async {
    emit(ProjectLoading());
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toJson());
      emit(ProjectLoaded(project));
    } catch (e) {
      emit(ProjectError('Failed to update project progress: ${e.toString()}'));
    }
  }

  double calculateOverallProgress(Project project) {
    int totalTasks = 0;
    int completedTasks = 0;
    for (var sprint in project.sprints) {
      for (var task in sprint.tasks) {
        totalTasks++;
        if (task.isCompleted) completedTasks++;
      }
    }
    return totalTasks > 0 ? completedTasks / totalTasks : 0;
  }

  double calculateSprintProgress(Sprint sprint) {
    int totalTasks = sprint.tasks.length;
    int completedTasks = sprint.tasks.where((task) => task.isCompleted).length;
    return totalTasks > 0 ? completedTasks / totalTasks : 0;
  }

  Future<void> fetchProjects() async {
    emit(ProjectLoading());
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      print('Fetching projects for user: ${currentUser.uid}');
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('startDate', descending: true)
          .get();

      print('Number of projects found: ${snapshot.docs.length}');

      final projects =
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList();

      print('Projects parsed: ${projects.length}');

      emit(ProjectsLoaded(projects));
    } catch (e) {
      print('Error fetching projects: $e');
      emit(ProjectError('Failed to fetch projects: ${e.toString()}'));
    }
  }

  Future<void> fetchProjectDetails(String projectId) async {
    emit(ProjectLoading());
    try {
      final doc = await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        final project = Project.fromJson(doc.data()!);
        emit(ProjectLoaded(project));
      } else {
        emit(const ProjectError('Project not found'));
      }
    } catch (e) {
      emit(ProjectError('Failed to fetch project details: ${e.toString()}'));
    }
  }
}

extension ProjectBlocExtension on ProjectBloc {
  void add(ProjectEvent event) {
    if (event is FetchProjects) {
      fetchProjects();
    } else if (event is LoadProject) {
      fetchProjectDetails(event.project.id);
    }
  }
}
