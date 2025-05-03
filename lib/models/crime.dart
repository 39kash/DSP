class Crime {
  final String category;
  final String location;
  final String outcome;
  final String date;
  final String? policingArea;

  Crime({
    required this.category,
    required this.location,
    required this.outcome,
    required this.date,
    this.policingArea,
  });

// Add fromJson and other logic as needed
}
