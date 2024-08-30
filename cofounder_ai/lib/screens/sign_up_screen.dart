import 'package:cofounder_ai/blocs/auth/signup_bloc.dart';
import 'package:cofounder_ai/blocs/auth/signup_event.dart';
import 'package:cofounder_ai/blocs/auth/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (BuildContext context, state) {
        if (state is SignupSuccess) {
          Navigator.pushReplacementNamed(context, '/main');
        } else if (state is SignupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Authentication',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                  "https://lottie.host/99cb1661-25d0-4da2-87d4-44fc30a90626/FVClPD7SVK.json"),
              BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
                return state is SignupLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: state is SignupLoading
                            ? null
                            : () {
                                context
                                    .read<SignupBloc>()
                                    .add(GoogleSignInRequested());
                              },
                        child: Text(
                          'Sign In with Google',
                          style: Theme.of(context).textTheme.titleMedium,
                        ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
