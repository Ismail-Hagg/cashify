import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part '../adaptors/transaction_data_model.g.dart';

@HiveType(typeId: 4)
class TransactionDataModel {
  @HiveField(0)
  String catagory;
  @HiveField(1)
  String subCatagory;
  @HiveField(2)
  String currency;
  @HiveField(3)
  double amount;
  @HiveField(4)
  String note;
  @HiveField(5)
  DateTime date;
  @HiveField(6)
  TransactionType type;
  @HiveField(7)
  String wallet;
  @HiveField(8)
  String fromWallet;
  @HiveField(9)
  String toWallet;
  @HiveField(10)
  String id;
  TransactionDataModel({
    required this.catagory,
    required this.subCatagory,
    required this.currency,
    required this.amount,
    required this.note,
    required this.date,
    required this.wallet,
    required this.fromWallet,
    required this.toWallet,
    required this.id,
    required this.type,
  });

  toMap() {
    return <String, dynamic>{
      'id': id,
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

  factory TransactionDataModel.fromMap(Map<String, dynamic> map) {
    return TransactionDataModel(
      id: map['id'],
      catagory: map['catagory'],
      subCatagory: map['subCatagory'],
      currency: map['currency'],
      amount: map['amount'].runtimeType != double
          ? double.parse(map['amount'].toString())
          : map['amount'],
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
