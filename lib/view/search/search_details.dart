import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:london_crime/models/crime_model.dart';

class SearchCrimeDetailsPage extends StatelessWidget {
  final CrimeModel crime;

  const SearchCrimeDetailsPage({super.key, required this.crime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Crime Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crime.category.capitalizeFirst ?? '',
              style: const TextStyle(fontSize: 24, color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("📍 Location: ${crime.location}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Text("🧾 Outcome: ${crime.outcome}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Text("📅 Date: ${crime.date}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            if (crime.policingArea != null)
              Text("👮‍♂️ Policing Area: ${crime.policingArea}",
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
