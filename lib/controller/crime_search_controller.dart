import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/crime_model.dart';
import '../service/crime_service.dart';
import '../service/notification_service.dart';

class CrimeSearchController extends GetxController {
  var isLoading = false.obs;
  RxString error = "".obs;
  var crimes = <CrimeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCrimesByLocation();
  }


  Future<void> fetchCrimes(String query) async {
    isLoading.value = true;

    final url = Uri.parse('https://data.police.uk/api/crimes-street/all-crime?lat=51.5074&lng=0.1278');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      crimes.value = data
          .map((json) => CrimeModel.fromJson(json))
          .where((c) =>
      c.category.toLowerCase().contains(query.toLowerCase()) ||
          c.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      crimes.value = [];
    }

    isLoading.value = false;
  }

  Future<void> fetchCrimesByLocation() async {
    try {
      isLoading.value = true;
      error.value = '';

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await CrimeService.fetchCrimes(
        lat: position.latitude,
        lng: position.longitude,
      );

      // Compare if there's new data (simple logic - can be improved with caching)
      if (data.isNotEmpty && data.length != crimes.length) {
        final latest = data.first;
        await NotificationService.showNotification(
          title: 'New Crime Alert!',
          body: '${latest.category} at ${latest.location}',
        );
      }

      crimes.value = data.cast<CrimeModel>();
    } catch (e) {
      error.value = 'Error fetching crime data: $e';
    } finally {
      isLoading.value = false;
    }
  }

}
