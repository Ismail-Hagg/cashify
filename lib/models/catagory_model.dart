import 'package:cashify/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Catagory {
  String name;
  List<dynamic> subCatagories;
  IconData icon;
  Color color;
  List<TransactionModel>? transactions;

  Catagory(
      {required this.name,
      required this.subCatagories,
      required this.icon,
      required this.color,
      this.transactions});

  toMap() {
    return <String, dynamic>{
      'name': name,
      'subCatagories': subCatagories,
      'icon': '${icon.codePoint}-${icon.fontFamily}',
      'color': color.value.toString()
    };
  }

  factory Catagory.fromMap(Map<String, dynamic> map) {
    return Catagory(
      name: map['name'],
      subCatagories: map['subCatagories'],
      icon: IconData(
        int.parse(
          map['icon'].toString().substring(
                0,
                map['icon'].toString().indexOf('-'),
              ),
        ),
        fontFamily: map['icon'].toString().substring(
              (map['icon'].toString().indexOf('-') + 1),
            ),
      ),
      color: Color(
        int.parse(map['color']),
      ),
    );
  }
}
