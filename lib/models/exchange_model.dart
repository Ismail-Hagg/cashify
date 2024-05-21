class CurrenctExchangeModel {
  String result;
  String errorMessage;
  String status;
  CurrenctExchangeModel({
    required this.result,
    required this.errorMessage,
    required this.status,
  });

  factory CurrenctExchangeModel.fromMap(Map<String, dynamic> map) {
    return CurrenctExchangeModel(
      result: (map['conversion_result'] as double).toStringAsFixed(2),
      errorMessage: map['error-type'] ?? '',
      status: map['result'],
    );
  }
}
