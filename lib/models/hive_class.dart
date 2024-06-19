import 'package:hive/hive.dart';
part 'hive_class.g.dart';

@HiveType(typeId: 1)
class MyCustomObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int value;

  MyCustomObject(this.name, this.value);

  toMap() {
    return <String, dynamic>{'name': name, 'value': value};
  }
}
