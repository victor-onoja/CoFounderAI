import 'package:cloud_firestore/cloud_firestore.dart';

class Idea {
  final String id;
  final String originalIdea;
  final String expandedIdea;
  final String userId;
  final DateTime timestamp;

  Idea({
    required this.id,
    required this.originalIdea,
    required this.expandedIdea,
    required this.userId,
    required this.timestamp,
  });

  factory Idea.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Idea(
      id: doc.id,
      originalIdea: data['originalIdea'] ?? '',
      expandedIdea: data['expandedIdea'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalIdea': originalIdea,
      'expandedIdea': expandedIdea,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
