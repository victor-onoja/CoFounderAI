import 'package:cofounder_ai/blocs/auth/signup_event.dart';
import 'package:cofounder_ai/blocs/auth/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SignupBloc() : super(SignupInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
