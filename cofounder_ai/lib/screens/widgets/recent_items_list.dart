import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentItemsList extends StatelessWidget {
  final List<Item> items = [
    Item(title: "AI-powered smart home", isProject: true, progress: 0.7),
    Item(title: "Sustainable fashion app", isProject: false, progress: 0.0),
    Item(
        title: "Virtual reality education platform",
        isProject: true,
        progress: 0.3),
    Item(title: "Blockchain for supply chain", isProject: false, progress: 0.0),
  ];

  RecentItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Recent Items",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ItemCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class Item {
  final String title;
  final bool isProject;
  final double progress;

  Item({required this.title, required this.isProject, required this.progress});
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // Navigate to item details
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item.isProject ? Icons.folder : Icons.lightbulb_outline,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (item.isProject)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: item.progress),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
