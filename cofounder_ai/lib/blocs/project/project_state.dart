import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/project.dart';

@immutable
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final Project project;

  const ProjectLoaded(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object> get props => [message];
}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;

  const ProjectsLoaded(this.projects);
}

abstract class ProjectEvent {}

class FetchProjects extends ProjectEvent {}

class LoadProject extends ProjectEvent {
  final Project project;

  LoadProject(this.project);
}
