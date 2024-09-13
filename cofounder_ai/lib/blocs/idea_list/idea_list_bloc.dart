import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cofounder_ai/models/idea.dart';
import 'idea_list_event.dart';
import 'idea_list_state.dart';

class IdeaListBloc extends Bloc<IdeaListEvent, IdeaListState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  IdeaListBloc() : super(IdeaListInitial()) {
    on<FetchIdeas>(_onFetchIdeas);
  }

  Future<void> _onFetchIdeas(
      FetchIdeas event, Emitter<IdeaListState> emit) async {
    emit(IdeaListLoading());
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('ideas')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

        final ideas =
            querySnapshot.docs.map((doc) => Idea.fromFirestore(doc)).toList();

        emit(IdeaListLoaded(ideas));
      } else {
        emit(const IdeaListError("User not authenticated"));
      }
    } catch (e) {
      emit(IdeaListError(e.toString()));
    }
  }
}
