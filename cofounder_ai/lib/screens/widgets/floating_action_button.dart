import 'package:flutter/material.dart';

class PulsingFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const PulsingFAB({super.key, required this.onPressed});

  @override
  _PulsingFABState createState() => _PulsingFABState();
}

class _PulsingFABState extends State<PulsingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
