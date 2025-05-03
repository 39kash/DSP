import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:london_crime/controller/crime_search_controller.dart';
import 'package:london_crime/models/crime_model.dart';
import 'search_details.dart';

class CrimeSearchPage extends StatelessWidget {
  final controller = Get.put(CrimeSearchController());
  final TextEditingController searchController = TextEditingController();

  CrimeSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🔍 London Crime Search'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Field with Glassmorphism
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search by crime type or location...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        controller.fetchCrimes(value);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔽 Results
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (controller.crimes.isEmpty) {
                  return const Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.crimes.length,
                    itemBuilder: (context, index) {
                      final crime = controller.crimes[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Colors.black87, Colors.black54],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => SearchCrimeDetailsPage(crime: crime),transition: Transition.rightToLeft);
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
                          title: Text(
                            crime.category.capitalizeFirst ?? '',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          subtitle: Text(
                            "📍 ${crime.location}\n🧾 Outcome: ${crime.outcome}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
