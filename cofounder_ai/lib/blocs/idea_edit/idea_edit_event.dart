import 'package:equatable/equatable.dart';

abstract class IdeaEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveIdea extends IdeaEditEvent {
  final String id;
  final String originalIdea;
  final String expandedIdea;

  SaveIdea(
      {required this.id,
      required this.originalIdea,
      required this.expandedIdea});
  @override
  List<Object?> get props => [id, originalIdea, expandedIdea];
}
