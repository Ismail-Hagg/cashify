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
}
