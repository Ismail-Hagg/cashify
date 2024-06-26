import 'package:hive/hive.dart';
part '../adaptors/wallet_data_model.g.dart';

@HiveType(typeId: 2)
class WalletModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String currency;
  WalletModel(
      {required this.name, required this.amount, required this.currency});

  toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'currency': currency
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
        name: map['name'], amount: map['amount'], currency: map['currency']);
  }
}
