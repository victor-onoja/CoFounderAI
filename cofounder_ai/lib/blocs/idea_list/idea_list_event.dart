import 'package:equatable/equatable.dart';

abstract class IdeaListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchIdeas extends IdeaListEvent {}
