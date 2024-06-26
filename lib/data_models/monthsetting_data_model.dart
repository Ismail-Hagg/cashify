import 'package:cashify/data_models/category_data_model.dart';
import 'package:cashify/data_models/walletinfo_data_model.dart';
import 'package:hive/hive.dart';
part '../adaptors/monthsetting_data_model.g.dart';

@HiveType(typeId: 5)
class MonthSettingDataModel {
  @HiveField(0)
  int month;
  @HiveField(1)
  List<WalletInfoModel> walletInfo;
  @HiveField(2)
  List<dynamic> budgetCat;
  @HiveField(3)
  List<dynamic> budgetVal;
  @HiveField(4)
  List<CatagoryModel> catagory;
  @HiveField(5)
  int year;
  MonthSettingDataModel({
    required this.walletInfo,
    required this.budgetCat,
    required this.budgetVal,
    required this.year,
    required this.month,
    required this.catagory,
  });

  Map<String, dynamic> toMap() {
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

  factory MonthSettingDataModel.fromMap(Map<String, dynamic> map) {
    List<CatagoryModel> lst = [];
    List<WalletInfoModel> walls = [];
    for (var element in map['catagory']) {
      lst.add(CatagoryModel.fromMap(element));
    }
    for (var element in map['walletInfo']) {
      walls.add(WalletInfoModel.fromMap(element));
    }

    return MonthSettingDataModel(
      year: map['year'],
      month: map['month'],
      budgetCat: map['budgetCat'],
      budgetVal: map['budgetVal'],
      catagory: lst,
      walletInfo: walls,
    );
  }
}
