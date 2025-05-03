class ForecastModel {
  final int year;
  final int value;

  ForecastModel({required this.year, required this.value});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      year: int.parse(json['year'].toString()),
      value: int.parse(json['value'].toString()),
    );
  }
}
