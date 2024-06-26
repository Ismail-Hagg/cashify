// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data_models/monthsetting_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthSettingDataModelAdapter extends TypeAdapter<MonthSettingDataModel> {
  @override
  final int typeId = 5;

  @override
  MonthSettingDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthSettingDataModel(
      walletInfo: (fields[1] as List).cast<WalletInfoModel>(),
      budgetCat: (fields[2] as List).cast<dynamic>(),
      budgetVal: (fields[3] as List).cast<dynamic>(),
      year: fields[5] as int,
      month: fields[0] as int,
      catagory: (fields[4] as List).cast<CatagoryModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MonthSettingDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.walletInfo)
      ..writeByte(2)
      ..write(obj.budgetCat)
      ..writeByte(3)
      ..write(obj.budgetVal)
      ..writeByte(4)
      ..write(obj.catagory)
      ..writeByte(5)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthSettingDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
