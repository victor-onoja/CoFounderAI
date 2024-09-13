import 'package:equatable/equatable.dart';

abstract class IdeaState extends Equatable {
  const IdeaState();
  @override
  List<Object?> get props => [];
}

class IdeaInitial extends IdeaState {}

class IdeaExpanding extends IdeaState {}

class IdeaExpanded extends IdeaState {
  final String expandedIdea;
  const IdeaExpanded(this.expandedIdea);
  @override
  List<Object?> get props => [expandedIdea];
}

class IdeaSaving extends IdeaState {}

class IdeaSaved extends IdeaState {}

class IdeaError extends IdeaState {
  final String error;
  const IdeaError(this.error);
  @override
  List<Object?> get props => [error];
}
