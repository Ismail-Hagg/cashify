import 'dart:convert';

import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/wallet_model.dart';

class UserModel {
  String username;
  String email;
  String userId;
  bool localImage;
  String localPath;
  String onlinePath;
  String language;
  String defaultCurrency;
  String messagingToken;
  String errorMessage;
  bool isError;
  String phoneNumber;
  List<Wallet> wallets;
  List<Catagory> catagories;
  UserModel(
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
      required this.catagories});

  toMap() {
    Map<String, dynamic> walls = {};
    Map<String, dynamic> cats = {};
    for (var i = 0; i < wallets.length; i++) {
      walls[wallets[i].name] = wallets[i].toMap();
    }
    for (var i = 0; i < catagories.length; i++) {
      cats[catagories[i].name] = catagories[i].toMap();
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
      'wallets': json.encode(walls),
      'catagories': json.encode(cats)
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> revert = json.decode(map['wallets']);
    Map<String, dynamic> revertCats = json.decode(map['catagories']);
    List<Wallet> lst = [];
    List<Catagory> cata = [];
    if (revert.isNotEmpty) {
      revert.forEach((key, value) {
        lst.add(Wallet.fromMap(value));
      });
    }
    if (revertCats.isNotEmpty) {
      revertCats.forEach((key, value) {
        cata.add(Catagory.fromMap(value));
      });
    }
    return UserModel(
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
        catagories: cata);
  }
}
