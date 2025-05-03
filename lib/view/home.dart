import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:london_crime/controller/crime_report_controller.dart';
import 'package:london_crime/service/crime_service.dart';
import 'package:london_crime/utils/theme/colors.dart';
import 'package:london_crime/utils/widgets/crime_category_barChart.dart';
import '../models/crime_data.dart';
import '../models/crime_report_model.dart';
import 'crime_details.dart';
import 'search/search_details.dart';

class OverViewCrimeStatsPage extends StatefulWidget {
  const OverViewCrimeStatsPage({super.key});

  @override
  State<OverViewCrimeStatsPage> createState() => _OverViewCrimeStatsPageState();
}

class _OverViewCrimeStatsPageState extends State<OverViewCrimeStatsPage> {
  final SubmitCrimeReportController controller = Get.put(SubmitCrimeReportController());
  late Future<List<CrimeData>> _crimeFuture;
  final List<String> months = [
    '2024-03',
    '2024-02',
    '2024-01',
    '2023-12',
    '2023-11',
    '2023-10',
    '2023-09',
  ];

  String selectedMonth = '2024-03';

  @override
  void initState() {
    super.initState();
    _loadCrimeData();
  }

  void _loadCrimeData() {
    setState(() {
      _crimeFuture = CrimeService.fetchCrimes(date: selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('📍 London Crime Overview'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<CrimeData>>(
        future: _crimeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent)));
          }

          final crimes = snapshot.data!;
          final Map<String, int> categoryCount = {};

          for (var crime in crimes) {
            categoryCount[crime.category] =
                (categoryCount[crime.category] ?? 0) + 1;
          }

          final entries = categoryCount.entries.toList();
          entries.sort((a, b) => b.value.compareTo(a.value)); // most to least

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📆 Select Month',
                  style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 8),
                _glassDropdown(),

                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '📊 Crime Count by Category - $selectedMonth',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                // Chart container
                _glassCard(
                  child: CrimeCategoryPieChart(data: entries.take(6).toList()),
                ),

                const SizedBox(height: 30),
                const Text(
                  '🕵️‍♂️ Crime Reports',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent),
                ),
                const SizedBox(height: 12),

                // Crime detail cards
                Obx(() {
                  if (controller.reports.isEmpty) {
                    return const Center(child: Text('No reports yet', style: TextStyle(color: Colors.white70)));
                  }

                  return Column(
                    children: controller.reports.map((report) => _crimeDetailCard(report)).toList(),
                  );
                }),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _glassDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        dropdownColor: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        value: selectedMonth,
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          if (value != null) {
            selectedMonth = value;
            _loadCrimeData();
          }
        },
        items: months.map((month) {
          return DropdownMenuItem(
            value: month,
            child: Text(month, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      //height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _crimeDetailCard(CrimeReport report) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CrimeDetailsPage(report: report),transition: Transition.rightToLeft);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: ListTile(
              leading: const Icon(Icons.report, color: Colors.orangeAccent),
              title: Text(
                report.crimeType.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Location: ${report.location}",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 16),
            ),
          ),
        ),
      ),
    );
  }

}
