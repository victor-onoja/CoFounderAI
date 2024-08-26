import 'package:cofounder_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoFounder AI',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00FFC6),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      initialRoute: '/',
      routes: {},
    );
  }
}
