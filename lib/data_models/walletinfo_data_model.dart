import 'package:hive/hive.dart';
part '../adaptors/walletinfo_data_model.g.dart';

@HiveType(typeId: 6)
class WalletInfoModel {
  @HiveField(0)
  String wallet;
  @HiveField(1)
  double start;
  @HiveField(2)
  double end;
  @HiveField(3)
  double opSum;
  @HiveField(4)
  String currency;

  WalletInfoModel(
      {required this.wallet,
      required this.start,
      required this.currency,
      required this.end,
      required this.opSum});

  toMap() {
    return <String, dynamic>{
      'wallet': wallet,
      'start': start,
      'end': end,
      'opSum': opSum,
      'currency': currency
    };
  }

  factory WalletInfoModel.fromMap(Map<String, dynamic> map) {
    double start = (map['start']).runtimeType == int
        ? double.parse(map['start'].toString())
        : map['start'];
    double end = (map['end']).runtimeType == int
        ? double.parse(map['end'].toString())
        : map['end'];
    double opSumm = (map['opSum']).runtimeType == int
        ? double.parse(map['opSum'].toString())
        : map['opSum'];
    return WalletInfoModel(
      wallet: map['wallet'],
      start: start,
      end: end,
      opSum: opSumm,
      currency: map['currency'],
    );
  }
}
