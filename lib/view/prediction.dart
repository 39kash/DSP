import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:london_crime/controller/forecast_controller.dart';

class AnalysisPage extends StatelessWidget {
  final controller = Get.put(ForecastController());

  AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("📊 London Crime Analysis"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final data = controller.forecasts;
        if (data.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              const Text(
                "🔮 Future Crime Trends in London",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Visualizing the predicted number of crimes per year using historical data trends.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 25),

              // GLASS CHART CONTAINER
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 260,
                        child: LineChart(
                          LineChartData(
                            backgroundColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.white.withOpacity(0.05),
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: Colors.white.withOpacity(0.05),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, _) {
                                    final idx = value.toInt();
                                    if (idx >= data.length) return const SizedBox.shrink();
                                    return SideTitleWidget(
                                      axisSide: AxisSide.bottom,
                                      child: Text(
                                        data[idx].year.toString(),
                                        style: const TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1000,
                                  getTitlesWidget: (value, _) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.asMap().entries.map((entry) {
                                  return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
                                }).toList(),
                                isCurved: true,
                                gradient: const LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.cyanAccent],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyanAccent.withOpacity(0.3),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "📅 Predicted Crime Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // PREDICTION CARDS
              ...data.map((item) => _predictionCard(item.year, item.value.toInt())).toList(),

              const SizedBox(height: 30),
              const Text(
                "📂 Data Source: Kaggle (London Crime Dataset)",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Card Widget for Each Yearly Prediction
  Widget _predictionCard(int year, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.redAccent),
            title: Text(
              "Year $year",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "$value predicted crimes",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}
