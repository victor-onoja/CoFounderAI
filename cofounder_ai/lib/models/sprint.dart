import 'package:cloud_firestore/cloud_firestore.dart';

class Sprint {
  final String id;
  final String title;
  final String description;
  final List<Task> tasks;
  final DateTime dueDate;
  bool isCompleted;

  Sprint(
      {required this.id,
      required this.title,
      required this.description,
      required this.tasks,
      required this.dueDate,
      required this.isCompleted});

  factory Sprint.fromJson(Map<String, dynamic> json) {
    return Sprint(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }
}
