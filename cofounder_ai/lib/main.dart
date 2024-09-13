import 'package:cofounder_ai/blocs/auth/signup_bloc.dart';
import 'package:cofounder_ai/blocs/idea/idea_bloc.dart';
import 'package:cofounder_ai/firebase_options.dart';
import 'package:cofounder_ai/screens/collaboration_screen.dart';
import 'package:cofounder_ai/screens/home_screen.dart';
import 'package:cofounder_ai/screens/idea_capture_screen.dart';
import 'package:cofounder_ai/screens/idea_screen.dart';
import 'package:cofounder_ai/screens/profile_screen.dart';
import 'package:cofounder_ai/screens/projects_screen.dart';
import 'package:cofounder_ai/screens/sign_up_screen.dart';
import 'package:cofounder_ai/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main_screen.dart';

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
      providers: [
        BlocProvider(create: (context) => SignupBloc()),
        BlocProvider(create: (context) => IdeaBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoFounder AI',
        theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFFB28DFF),
            scaffoldBackgroundColor: const Color(0xFF0A0E21),
            textTheme: TextTheme(
                titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                bodyMedium: GoogleFonts.roboto(),
                displaySmall: GoogleFonts.montserrat())),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/main': (context) => const MainScreen(),
          '/home': (context) => const HomeScreen(),
          '/ideas': (context) => const IdeaScreen(),
          '/idea-capture': (context) => const IdeaCaptureScreen(),
          '/projects': (context) => const ProjectsScreen(),
          '/collaborations': (context) => const CollaborationScreen(),
          '/profile': (context) => const ProfileScreen()
        },
      ),
    );
  }
}
