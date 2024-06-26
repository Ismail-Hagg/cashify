import 'package:hive/hive.dart';
part '../adaptors/enums.g.dart';

enum ButtonType { text, outlined, raised }

enum AvatarType { online, local, loading, none }

enum FieldType { email, password, username, phone, otp }

enum FirebasePaths { users, transactions, monthSetting }

@HiveType(typeId: 7)
enum TransactionType {
  @HiveField(0)
  moneyIn,
  @HiveField(1)
  moneyOut,
  @HiveField(2)
  transfer
}

enum Times { thisMonth, lastMonth, thisYear, custom }

enum ExpenseTile { loading, expense, category }
