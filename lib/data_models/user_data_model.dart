import 'package:cashify/data_models/category_data_model.dart';
import 'package:cashify/data_models/wallet_data_model.dart';
import 'package:hive/hive.dart';
part '../adaptors/user_data_model.g.dart';

@HiveType(typeId: 1)
class UserDataModel {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String userId;

  @HiveField(3)
  bool localImage;

  @HiveField(4)
  String localPath;

  @HiveField(5)
  String onlinePath;

  @HiveField(6)
  String language;

  @HiveField(7)
  String defaultCurrency;

  @HiveField(8)
  String messagingToken;

  @HiveField(9)
  String errorMessage;

  @HiveField(10)
  bool isError;

  @HiveField(11)
  String phoneNumber;

  @HiveField(12)
  List<WalletModel> wallets;

  @HiveField(13)
  List<CatagoryModel> catagories;

  @HiveField(14)
  bool isSynced;

  UserDataModel(
      {required this.username,
      required this.email,
      required this.userId,
      required this.localImage,
      required this.localPath,
      required this.onlinePath,
      required this.language,
      required this.defaultCurrency,
      required this.messagingToken,
      required this.errorMessage,
      required this.phoneNumber,
      required this.wallets,
      required this.isError,
      required this.catagories,
      required this.isSynced});

  toMap() {
    List<Map<String, dynamic>> walls = [];
    List<Map<String, dynamic>> cats = [];
    for (var i = 0; i < wallets.length; i++) {
      walls.add(wallets[i].toMap());
    }
    for (var i = 0; i < catagories.length; i++) {
      cats.add(catagories[i].toMap());
    }
    return <String, dynamic>{
      'username': username,
      'email': email,
      'userId': userId,
      'localImage': localImage,
      'localPath': localPath,
      'onlinePath': onlinePath,
      'language': language,
      'defaultCurrency': defaultCurrency,
      'messagingToken': messagingToken,
      'errorMessage': errorMessage,
      'isError': isError,
      'phoneNumber': phoneNumber,
      'wallets': walls,
      'catagories': cats,
      'isSynced': isSynced
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> revert = map['wallets'] ?? [];
    List<dynamic> revertCats = map['catagories'];
    List<WalletModel> lst = [];
    List<CatagoryModel> cata = [];
    for (var i = 0; i < revert.length; i++) {
      lst.add(WalletModel.fromMap(revert[i]));
    }
    for (var i = 0; i < revertCats.length; i++) {
      cata.add(CatagoryModel.fromMap(revertCats[i]));
    }
    return UserDataModel(
        username: map['username'],
        email: map['email'],
        userId: map['userId'],
        localImage: map['localImage'],
        localPath: map['localPath'],
        onlinePath: map['onlinePath'],
        language: map['language'],
        defaultCurrency: map['defaultCurrency'],
        messagingToken: map['messagingToken'],
        errorMessage: map['errorMessage'],
        isError: map['isError'],
        phoneNumber: map['phoneNumber'],
        wallets: lst,
        catagories: cata,
        isSynced: map['isSynced']);
  }
}
