import 'package:equatable/equatable.dart';
import 'package:cofounder_ai/models/idea.dart';

abstract class IdeaListState extends Equatable {
  const IdeaListState();

  @override
  List<Object> get props => [];
}

class IdeaListInitial extends IdeaListState {}

class IdeaListLoading extends IdeaListState {}

class IdeaListLoaded extends IdeaListState {
  final List<Idea> ideas;

  const IdeaListLoaded(this.ideas);

  @override
  List<Object> get props => [ideas];
}

class IdeaListError extends IdeaListState {
  final String message;

  const IdeaListError(this.message);

  @override
  List<Object> get props => [message];
}
