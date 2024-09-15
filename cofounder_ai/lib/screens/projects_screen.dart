import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://lottie.host/dd19af24-e56d-41bb-a9fe-f35cb54b43e7/bKqLWqEBxo.json'),
          const SizedBox(
            height: 32,
          ),
          const Text('Projects Screen'),
        ],
      ),
    ));
  }
}
