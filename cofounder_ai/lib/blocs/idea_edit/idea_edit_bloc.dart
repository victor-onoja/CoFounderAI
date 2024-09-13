import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'idea_edit_event.dart';
import 'idea_edit_state.dart';

class IdeaEditBloc extends Bloc<IdeaEditEvent, IdeaEditState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  IdeaEditBloc() : super(IdeaEditInitial()) {
    on<SaveIdea>(_onSaveIdea);
  }

  Future<void> _onSaveIdea(SaveIdea event, Emitter<IdeaEditState> emit) async {
    emit(IdeaEditLoading());
    try {
      await _firestore.collection('ideas').doc(event.id).update({
        'originalIdea': event.originalIdea,
        'expandedIdea': event.expandedIdea,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(IdeaEditSuccess());
    } catch (e) {
      emit(IdeaEditFailure(e.toString()));
    }
  }
}
