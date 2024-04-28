import 'package:cashify/models/transaction_model.dart';
import 'package:flutter/material.dart';

class Catagory {
  String name;
  List<String> subCatagories;
  String icon;
  Color? color;
  List<Transaction>? transactions;

  Catagory(
      {required this.name,
      required this.subCatagories,
      required this.icon,
      this.color,
      this.transactions});

  toMap() {
    return <String, dynamic>{
      'name': name,
      'subCatagories': subCatagories,
      'icon': icon,
    };
  }

  factory Catagory.fromMap(Map<String, dynamic> map) {
    return Catagory(
        name: map['name'],
        subCatagories: map['subCatagories'],
        icon: map['icon']);
  }
}
