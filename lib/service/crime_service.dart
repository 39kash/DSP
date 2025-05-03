import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crime_data.dart';

class CrimeService {
  static Future<List<CrimeData>> fetchCrimes({
    double lat = 51.5074,
    double lng = -0.1278,
    String date = '2023-12',
  }) async {
    final url = Uri.parse(
      'https://data.police.uk/api/crimes-at-location?date=$date&lat=$lat&lng=$lng',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => CrimeData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load crime data');
    }
  }
}
