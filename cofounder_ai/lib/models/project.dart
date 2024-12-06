import 'package:cloud_firestore/cloud_firestore.dart';

import 'sprint.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final List<Sprint> sprints;
  final DateTime startDate;
  final String userId;

  Project({
    required this.description,
    required this.id,
    required this.title,
    required this.sprints,
    required this.startDate,
    required this.userId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sprints:
          (json['sprints'] as List).map((s) => Sprint.fromJson(s)).toList(),
      startDate: (json['startDate'] as Timestamp).toDate(),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'sprints': sprints.map((s) => s.toJson()).toList(),
      'startDate': Timestamp.fromDate(startDate),
      'userId': userId
    };
  }
}
