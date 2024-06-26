import 'package:cashify/data_models/transaction_data_model.dart';
import 'package:hive/hive.dart';
part '../adaptors/category_data_model.g.dart';

@HiveType(typeId: 3)
class CatagoryModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<dynamic> subCatagories;

  @HiveField(2)
  String icon;

  @HiveField(3)
  int color;

  @HiveField(4)
  List<TransactionDataModel>? transactions;

  CatagoryModel(
      {required this.name,
      required this.subCatagories,
      required this.icon,
      required this.color,
      this.transactions});

  toMap() {
    return <String, dynamic>{
      'name': name,
      'subCatagories': subCatagories,
      'icon': icon,
      'color': color
    };
  }

  factory CatagoryModel.fromMap(Map<String, dynamic> map) {
    return CatagoryModel(
      name: map['name'],
      subCatagories: map['subCatagories'],
      icon: map['icon'],
      color: map['color'],
    );
  }
}
