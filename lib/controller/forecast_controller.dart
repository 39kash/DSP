import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/forecast_model.dart';

class ForecastController extends GetxController {
  var forecasts = <ForecastModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
  }

  Future<void> loadForecastData() async {
    final data = await rootBundle.loadString('assets/forecast.json');
    final List<dynamic> jsonResult = json.decode(data);
    forecasts.value = jsonResult.map((e) => ForecastModel.fromJson(e)).toList();
  }
}
