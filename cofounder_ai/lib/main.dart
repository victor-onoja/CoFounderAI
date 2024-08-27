import 'package:cofounder_ai/blocs/auth/signup_bloc.dart';
import 'package:cofounder_ai/firebase_options.dart';
import 'package:cofounder_ai/screens/home_screen.dart';
import 'package:cofounder_ai/screens/sign_up_screen.dart';
import 'package:cofounder_ai/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SignupBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoFounder AI',
        theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF00FFC6),
            scaffoldBackgroundColor: const Color(0xFF0A0E21),
            textTheme: const TextTheme(
                titleLarge: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(fontFamily: 'Roboto'),
                displaySmall: TextStyle(fontFamily: 'Montserrat'))),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen()
        },
      ),
    );
  }
}
