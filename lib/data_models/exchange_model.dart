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
    double res = map['conversion_result'].runtimeType != double
        ? double.parse(map['conversion_result'].toString())
        : map['conversion_result'];
    return CurrenctExchangeModel(
      result: res.toStringAsFixed(2),
      errorMessage: map['error-type'] ?? '',
      status: map['result'],
    );
  }
}
