class CrimeModel {
  final String category;
  final String location;
  final String outcome;
  final String date;
  final String? policingArea;

  CrimeModel({
    required this.category,
    required this.location,
    required this.outcome,
    required this.date,
    this.policingArea,
  });

  factory CrimeModel.fromJson(Map<String, dynamic> json) {
    return CrimeModel(
      category: json['category'] ?? '',
      location: json['location']['street']['name'] ?? '',
      outcome: json['outcome_status']?['category'] ?? 'Unknown',
      date: json['month'] ?? '',
      policingArea: json['persistent_id'], // optional example
    );
  }
}
