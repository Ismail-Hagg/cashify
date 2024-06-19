// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyCustomObjectAdapter extends TypeAdapter<MyCustomObject> {
  @override
  final int typeId = 1;

  @override
  MyCustomObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyCustomObject(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MyCustomObject obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCustomObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
