import 'package:cloud_firestore/cloud_firestore.dart';

class FilterModel {
  String userId;
  String path;
  Timestamp? timeStart;
  Timestamp? timeEnd;
  String? cuurency;
  double? eqbig;
  double? small;
  String? category;
  String? subCat;
  FilterModel({
    required this.userId,
    required this.path,
    this.timeStart,
    this.timeEnd,
    this.cuurency,
    this.eqbig,
    this.small,
    this.category,
    this.subCat,
  });
}
