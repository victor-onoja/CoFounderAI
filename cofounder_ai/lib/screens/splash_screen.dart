import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadSplash();
  }

  Future<Timer> loadSplash() async {
    return Timer(
      const Duration(seconds: 3),
      onDoneLoading,
    );
  }

  onDoneLoading() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              "https://lottie.host/a3fd5afb-4243-44fd-ae2b-e9ca29f072ca/kbgmaKyATW.json"),
          Text(
            'CoFounder AI',
            style: Theme.of(context).textTheme.displaySmall,
          )
        ],
      ),
    );
  }
}
