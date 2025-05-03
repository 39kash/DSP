import 'package:get/get.dart';
import 'package:london_crime/models/crime_state_model.dart';

class CrimeStatsController extends GetxController {
  var stats = <CrimeStats>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    stats.value = [
      CrimeStats(category: "Violent Crime", count: 3200),
      CrimeStats(category: "Robbery", count: 850),
      CrimeStats(category: "Burglary", count: 1200),
      CrimeStats(category: "Drugs", count: 600),
      CrimeStats(category: "Theft", count: 2700),
    ];
  }
}
