import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
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
  TransactionModel({
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
      'date': Timestamp.fromDate(date),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      catagory: map['catagory'],
      subCatagory: map['subCatagory'],
      currency: map['currency'],
      amount: map['amount'],
      note: map['note'],
      date: map['date'].runtimeType == String
          ? DateTime.parse(map['date'])
          : (map['date'] as Timestamp).toDate(),
      wallet: map['wallet'],
      fromWallet: map['fromWallet'],
      toWallet: map['toWallet'],
      type:
          TransactionType.values.firstWhere((e) => e.toString() == map['type']),
    );
  }
}
