import 'package:equatable/equatable.dart';

abstract class IdeaEditState extends Equatable {
  const IdeaEditState();

  @override
  List<Object> get props => [];
}

class IdeaEditInitial extends IdeaEditState {}

class IdeaEditLoading extends IdeaEditState {}

class IdeaEditSuccess extends IdeaEditState {}

class IdeaEditFailure extends IdeaEditState {
  final String error;

  const IdeaEditFailure(this.error);

  @override
  List<Object> get props => [error];
}
