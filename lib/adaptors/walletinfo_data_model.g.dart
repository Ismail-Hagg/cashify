// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data_models/walletinfo_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletInfoModelAdapter extends TypeAdapter<WalletInfoModel> {
  @override
  final int typeId = 6;

  @override
  WalletInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletInfoModel(
      wallet: fields[0] as String,
      start: fields[1] as double,
      currency: fields[4] as String,
      end: fields[2] as double,
      opSum: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalletInfoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.wallet)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.opSum)
      ..writeByte(4)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
