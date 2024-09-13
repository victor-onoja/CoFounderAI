import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'idea_event.dart';
import 'idea_state.dart';

class IdeaBloc extends Bloc<IdeaEvent, IdeaState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const apikey = "AIzaSyD_oL-0jXjJ3qgQsJ7lzah-fs6p5j2PMtE";
  final model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apikey);

  IdeaBloc() : super(IdeaInitial()) {
    on<ExpandIdea>(_onExpandIdea);
    on<SaveIdea>(_onSaveIdea);
  }

  Future<void> _onExpandIdea(ExpandIdea event, Emitter<IdeaState> emit) async {
    emit(IdeaExpanding());
    try {
      String expandedIdea = await _expandIdeaWithAI(event.idea);
      emit(IdeaExpanded(expandedIdea));
    } catch (e) {
      emit(IdeaError("Failed to expand idea: $e"));
    }
  }

  Future<void> _onSaveIdea(SaveIdea event, Emitter<IdeaState> emit) async {
    emit(IdeaSaving());
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('ideas').add({
          'userId': user.uid,
          'originalIdea': event.originalIdea,
          'expandedIdea': event.expandedIdea,
          'timestamp': FieldValue.serverTimestamp(),
        });
        emit(IdeaSaved());
      } else {
        emit(const IdeaError("User not authenticated"));
      }
    } catch (e) {
      emit(IdeaError("Failed to save idea: $e"));
    }
  }

  Future<String> _expandIdeaWithAI(String idea) async {
    final prompt =
        "You're an experienced business analyst and strategist. Analyze this text $idea. Be creative and strategic in your analysis and give your response in this format: Expanded idea: [Original Idea]\n\n1. Market analysis\n2. Key features\n3. Target audience\n4. Revenue model\n5. Development roadmap";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ??
        "Sorry, the AI could not generate an idea at this time.";
  }
}
