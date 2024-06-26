// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data_models/user_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataModelAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 1;

  @override
  UserDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataModel(
      username: fields[0] as String,
      email: fields[1] as String,
      userId: fields[2] as String,
      localImage: fields[3] as bool,
      localPath: fields[4] as String,
      onlinePath: fields[5] as String,
      language: fields[6] as String,
      defaultCurrency: fields[7] as String,
      messagingToken: fields[8] as String,
      errorMessage: fields[9] as String,
      phoneNumber: fields[11] as String,
      wallets: (fields[12] as List).cast<WalletModel>(),
      isError: fields[10] as bool,
      catagories: (fields[13] as List).cast<CatagoryModel>(),
      isSynced: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.localImage)
      ..writeByte(4)
      ..write(obj.localPath)
      ..writeByte(5)
      ..write(obj.onlinePath)
      ..writeByte(6)
      ..write(obj.language)
      ..writeByte(7)
      ..write(obj.defaultCurrency)
      ..writeByte(8)
      ..write(obj.messagingToken)
      ..writeByte(9)
      ..write(obj.errorMessage)
      ..writeByte(10)
      ..write(obj.isError)
      ..writeByte(11)
      ..write(obj.phoneNumber)
      ..writeByte(12)
      ..write(obj.wallets)
      ..writeByte(13)
      ..write(obj.catagories)
      ..writeByte(14)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
