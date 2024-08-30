import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIQuoteWidget extends StatefulWidget {
  const AIQuoteWidget({super.key});

  @override
  _AIQuoteWidgetState createState() => _AIQuoteWidgetState();
}

class _AIQuoteWidgetState extends State<AIQuoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Timer _timer;

  final List<String> quotes = [
    "Turn your ideas into reality.",
    "Innovation is the key to success.",
    "Every project starts with a single thought.",
    "Embrace the power of AI in your creative journey.",
    "Collaboration amplifies creativity.",
  ];

  String currentQuote = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _updateQuote();

    // Set up a timer to change the quote every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateQuote();
    });
  }

  void _updateQuote() {
    setState(() {
      String newQuote;
      do {
        newQuote = quotes[Random().nextInt(quotes.length)];
      } while (newQuote == currentQuote && quotes.length > 1);
      currentQuote = newQuote;
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _updateQuote,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            currentQuote,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Don't forget to cancel the timer when disposing
    super.dispose();
  }
}
