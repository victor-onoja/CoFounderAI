import 'package:cofounder_ai/blocs/project/project_bloc.dart';
import 'package:cofounder_ai/blocs/project/project_state.dart';
import 'package:cofounder_ai/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/sprint.dart';
import '../models/task.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc()..add(LoadProject(project)),
      child: BlocConsumer<ProjectBloc, ProjectState>(
        builder: (context, state) {
          print('Current state in ProjectDetailsScreen: $state');
          if (state is ProjectLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ProjectLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.project.title),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: ProjectTimeline(project: state.project),
            );
          } else if (state is ProjectError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProjectBloc>().add(LoadProject(project)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text(
                'Something went wrong',
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is ProjectError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }
}

class ProjectTimeline extends StatelessWidget {
  final Project project;
  const ProjectTimeline({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final projectBloc = context.read<ProjectBloc>();
    final overallProgress = projectBloc.calculateOverallProgress(project);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: overallProgress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 4),
              Text('${(overallProgress * 100).toStringAsFixed(1)}%'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: project.sprints.length,
            itemBuilder: (context, index) {
              final sprint = project.sprints[index];
              return SprintCard(sprint: sprint);
            },
          ),
        ),
      ],
    );
  }
}

class SprintCard extends StatelessWidget {
  final Sprint sprint;

  const SprintCard({super.key, required this.sprint});

  @override
  Widget build(BuildContext context) {
    final projectBloc = context.read<ProjectBloc>();
    final sprintProgress = projectBloc.calculateSprintProgress(sprint);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              sprint.isCompleted ? Colors.green.withOpacity(0.1) : Colors.black,
        ),
        child: ExpansionTile(
          title: Text(sprint.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Due: ${sprint.dueDate.toString().split('')[0]}'),
              const SizedBox(height: 4),
              Text(
                '${sprint.description.substring(0, 50)}...',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: sprintProgress,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  sprint.isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 2),
              Text('${(sprintProgress * 100).toStringAsFixed(1)}%'),
            ],
          ),
          children:
              // sprint.tasks
              //     .map((task) => TaskItem(
              //           task: task,
              //           sprint: sprint,
              //         ))
              //     .toList()
              [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(sprint.description), // Full description
            ),
            ...sprint.tasks.map((task) => TaskItem(task: task, sprint: sprint)),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final Sprint sprint;
  const TaskItem({super.key, required this.task, required this.sprint});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Tooltip(
        message: task.description,
        child: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.blue),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(task.description)),
                );
              },
            ),
          ],
        ),
      ),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Checkbox(
            key: ValueKey(task.isCompleted),
            value: task.isCompleted,
            onChanged: (value) {
              task.isCompleted = value ?? false;
              sprint.isCompleted = sprint.tasks.every((t) => t.isCompleted);
              context.read<ProjectBloc>().updateProjectProgress(
                  (context.read<ProjectBloc>().state as ProjectLoaded).project);
            }),
      ),
    );
  }
}
