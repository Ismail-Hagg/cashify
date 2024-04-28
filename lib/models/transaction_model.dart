import 'package:cashify/utils/enums.dart';

class Transaction {
  String catagory;
  String subCatagory;
  String currency;
  double amount;
  String note;
  DateTime date;
  TransactionType type;
  String wallet;
  String fromWallet;
  String toWallet;
  Transaction({
    required this.catagory,
    required this.subCatagory,
    required this.currency,
    required this.amount,
    required this.note,
    required this.date,
    required this.wallet,
    required this.fromWallet,
    required this.toWallet,
    required this.type,
  });

  toMap() {
    return <String, dynamic>{
      'catagory': catagory,
      'subCatagory': subCatagory,
      'currency': currency,
      'amount': amount,
      'note': note,
      'type': type.toString(),
      'wallet': wallet,
      'fromWallet': fromWallet,
      'toWallet': toWallet,
      'date': date.toString(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      catagory: map['catagory'],
      subCatagory: map['subCatagory'],
      currency: map['currency'],
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      wallet: map['wallet'],
      fromWallet: map['fromWallet'],
      toWallet: map['toWallet'],
      type:
          TransactionType.values.firstWhere((e) => e.toString() == map['type']),
    );
  }
}
