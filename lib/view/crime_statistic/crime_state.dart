import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:london_crime/controller/crime_state_controller.dart';

import 'crime_details.dart';

class CrimeStatsPage extends StatelessWidget {
  final controller = Get.put(CrimeStatsController());

  CrimeStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("📊 Crime Statistics - London"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final stats = controller.stats;
        if (stats.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }

        final total = stats.fold(0, (sum, item) => sum + item.count);
        final colors = [
          Colors.redAccent,
          Colors.blueAccent,
          Colors.green,
          Colors.orangeAccent,
          Colors.purpleAccent,
          Colors.tealAccent,
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🚨 Crime Breakdown",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              const SizedBox(height: 20),

              // Pie Chart inside a glass card
              _glassCard(
                height: 240,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(stats.length, (i) {
                      final item = stats[i];
                      final percent = (item.count / total * 100).toStringAsFixed(1);
                      return PieChartSectionData(
                        color: colors[i % colors.length],
                        value: item.count.toDouble(),
                        title: "$percent%",
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "📌 Crime Types Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Bar Chart inside a glass card
              _glassCard(
                height: 240,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            if (value.toInt() >= stats.length) return const SizedBox.shrink();
                            return SideTitleWidget(
                              axisSide: AxisSide.bottom,
                              child: Text(
                                stats[value.toInt()].category.split(" ")[0],
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            );
                          },
                          reservedSize: 32,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: stats.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: item.count.toDouble(),
                            color: colors[index % colors.length],
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "📋 Detailed Crime State Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              const SizedBox(height: 12),

              // Detailed Crime Cards
              ...stats.map((item) => _crimeDetailCard(item.category, item.count)).toList(),

              const SizedBox(height: 30),
              const Text(
                "📂 Source: Office for National Statistics, data.london.gov.uk",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Glass card wrapper
  Widget _glassCard({required double height, required Widget child}) {
    return Container(
      height: height,
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

  // Crime detail card
  Widget _crimeDetailCard(String category, int count) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CrimeDetailPage(category: category, count: count),transition: Transition.rightToLeft);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              leading: const Icon(Icons.security, color: Colors.redAccent),
              title: Text(
                category,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "$count reported cases",
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
