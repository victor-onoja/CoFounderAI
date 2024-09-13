import 'package:cofounder_ai/screens/widgets/recent_items_list.dart';
import 'package:flutter/material.dart';

import 'widgets/ai_quote_widget.dart';
import 'widgets/floating_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cofounder AI')),
      body: Column(
        children: [const AIQuoteWidget(), RecentItemsList()],
      ),
      floatingActionButton: PulsingFAB(onPressed: () {
        Navigator.pushNamed(context, '/idea-capture');
      }),
    );
  }
}
