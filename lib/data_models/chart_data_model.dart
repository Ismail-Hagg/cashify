class ChartDataModel {
  double high;
  double low;
  Map<DateTime, double> data;
  String name;
  DateTime start;
  DateTime end;

  ChartDataModel({
    required this.high,
    required this.low,
    required this.data,
    required this.name,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toMap() {
    return {
      'high': high,
      'low': low,
      'data': data,
      'name': name,
      'start': start,
      'end': end,
    };
  }
}
