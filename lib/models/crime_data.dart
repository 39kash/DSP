class CrimeData {
  final String category;
  final String location;
  final String month;
  final double? locationLat;
  final double? locationLng;

  CrimeData({
    required this.category,
    required this.location,
    required this.month,
    this.locationLat,
    this.locationLng,
  });

  factory CrimeData.fromJson(Map<String, dynamic> json) {
    return CrimeData(
      category: json['category'] ?? '',
      location: json['location']['street']['name'] ?? '',
      month: json['month'] ?? '',
      locationLat: json['location']['latitude'] != null
          ? double.tryParse(json['location']['latitude'])
          : null,
      locationLng: json['location']['longitude'] != null
          ? double.tryParse(json['location']['longitude'])
          : null,
    );
  }
}
