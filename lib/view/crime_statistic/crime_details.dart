import 'package:flutter/material.dart';

class CrimeDetailPage extends StatelessWidget {
  final String category;
  final int count;

  const CrimeDetailPage({super.key, required this.category, required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📌 Category: $category",
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "🔢 Reported Cases: $count",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text(
              "📝 Description:",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "This crime category includes incidents reported in London based on official crime data sources. "
                  "For further insights or trends over time, consult official open data repositories.",
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
