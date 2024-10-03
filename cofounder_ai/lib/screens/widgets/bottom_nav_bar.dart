import 'package:flutter/material.dart';

class AnimatedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  AnimatedBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.lightbulb_outlined,
    Icons.work_outlined,
    Icons.quickreply_outlined,
    Icons.people_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _icons[index],
                color: currentIndex == index
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
          );
        }),
      ),
    );
  }
}
