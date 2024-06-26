// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data_models/transaction_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionDataModelAdapter extends TypeAdapter<TransactionDataModel> {
  @override
  final int typeId = 4;

  @override
  TransactionDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionDataModel(
      catagory: fields[0] as String,
      subCatagory: fields[1] as String,
      currency: fields[2] as String,
      amount: fields[3] as double,
      note: fields[4] as String,
      date: fields[5] as DateTime,
      wallet: fields[7] as String,
      fromWallet: fields[8] as String,
      toWallet: fields[9] as String,
      id: fields[10] as String,
      type: fields[6] as TransactionType,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionDataModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.catagory)
      ..writeByte(1)
      ..write(obj.subCatagory)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.wallet)
      ..writeByte(8)
      ..write(obj.fromWallet)
      ..writeByte(9)
      ..write(obj.toWallet)
      ..writeByte(10)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
