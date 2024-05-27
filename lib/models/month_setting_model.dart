import 'package:cashify/models/catagory_model.dart';

class MonthSettingModel {
  int year;
  int month;
  List<WalletInfo> walletInfo;
  List<dynamic> budgetCat;
  List<dynamic> budgetVal;
  List<Catagory> catagory;
  MonthSettingModel({
    required this.walletInfo,
    required this.budgetCat,
    required this.budgetVal,
    required this.year,
    required this.month,
    required this.catagory,
  });

  toMap() {
    List<Map<String, dynamic>> cats = [];
    List<Map<String, dynamic>> wallets = [];
    for (var element in catagory) {
      cats.add(element.toMap());
    }
    for (var element in walletInfo) {
      wallets.add(element.toMap());
    }
    return <String, dynamic>{
      'year': year,
      'month': month,
      'budgetCat': budgetCat,
      'budgetVal': budgetVal,
      'walletInfo': wallets,
      'catagory': cats,
    };
  }

  factory MonthSettingModel.fromMap(Map<String, dynamic> map) {
    List<Catagory> lst = [];
    List<WalletInfo> walls = [];
    for (var element in map['catagory']) {
      lst.add(Catagory.fromMap(element));
    }
    for (var element in map['walletInfo']) {
      walls.add(WalletInfo.fromMap(element));
    }

    return MonthSettingModel(
      year: map['year'],
      month: map['month'],
      budgetCat: map['budgetCat'],
      budgetVal: map['budgetVal'],
      catagory: lst,
      walletInfo: walls,
    );
  }
}

class WalletInfo {
  String wallet;
  double start;
  double end;
  double opSum;
  WalletInfo(
      {required this.wallet,
      required this.start,
      required this.end,
      required this.opSum});

  toMap() {
    return <String, dynamic>{
      'wallet': wallet,
      'start': start,
      'end': end,
      'opSum': opSum
    };
  }

  factory WalletInfo.fromMap(Map<String, dynamic> map) {
    double start = (map['start']).runtimeType == int
        ? double.parse(map['start'].toString())
        : map['start'];
    double end = (map['end']).runtimeType == int
        ? double.parse(map['end'].toString())
        : map['end'];
    double opSumm = (map['opSum']).runtimeType == int
        ? double.parse(map['opSum'].toString())
        : map['opSum'];
    return WalletInfo(
        wallet: map['wallet'], start: start, end: end, opSum: opSumm);
  }
}
