import 'package:equatable/equatable.dart';

abstract class IdeaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpandIdea extends IdeaEvent {
  final String idea;
  ExpandIdea(this.idea);

  @override
  List<Object?> get props => [idea];
}

class SaveIdea extends IdeaEvent {
  final String originalIdea;
  final String expandedIdea;
  SaveIdea(this.originalIdea, this.expandedIdea);

  @override
  List<Object?> get props => [originalIdea, expandedIdea];
}
