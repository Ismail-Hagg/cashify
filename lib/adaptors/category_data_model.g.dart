// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data_models/category_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatagoryModelAdapter extends TypeAdapter<CatagoryModel> {
  @override
  final int typeId = 3;

  @override
  CatagoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatagoryModel(
      name: fields[0] as String,
      subCatagories: (fields[1] as List).cast<dynamic>(),
      icon: fields[2] as String,
      color: fields[3] as int,
      transactions: (fields[4] as List?)?.cast<TransactionDataModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CatagoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.subCatagories)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatagoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
