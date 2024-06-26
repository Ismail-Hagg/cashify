import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';

import '../data_models/export.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  // initialize hive
  Future<void> hiveInit() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserDataModelAdapter());
    Hive.registerAdapter(CatagoryModelAdapter());
    Hive.registerAdapter(TransactionDataModelAdapter());
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(MonthSettingDataModelAdapter());
    Hive.registerAdapter(WalletInfoModelAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
  }

  // get box
  Future<Box<T>> getBox<T>({required String boxName}) async {
    if (Hive.isBoxOpen(boxName) == false) {
      await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  // creaet or update user data
  Future<void> saveUser({required UserDataModel model}) async {
    Box<UserDataModel> box = await getBox<UserDataModel>(boxName: userBox);
    await box.put(userData, model);
  }

  // get user data
  Future<UserDataModel> getUserData() async {
    try {
      Box<UserDataModel> box = await getBox<UserDataModel>(boxName: userBox);
      return box.get(userData) ??
          UserDataModel(
            username: '',
            email: '',
            userId: '',
            localImage: false,
            localPath: '',
            onlinePath: '',
            language: languageDev(),
            defaultCurrency: '',
            messagingToken: '',
            errorMessage: 'no data saved',
            phoneNumber: '',
            wallets: [],
            isError: true,
            catagories: [],
            isSynced: false,
          );
    } catch (e) {
      return UserDataModel(
        username: '',
        email: '',
        userId: '',
        localImage: false,
        localPath: '',
        onlinePath: '',
        language: languageDev(),
        defaultCurrency: '',
        messagingToken: '',
        errorMessage: e.toString(),
        phoneNumber: '',
        wallets: [],
        isError: true,
        catagories: [],
        isSynced: false,
      );
    }
  }

  // get transaction list
  Future<List<dynamic>> getTransactionList() async {
    Box<List<dynamic>> box =
        await getBox<List<dynamic>>(boxName: transactionBox);
    return box.get(userTransacitons) ?? [];
  }

  // save transaction
  Future<void> saveTransaction({required List<dynamic> list}) async {
    Box<List<dynamic>> box =
        await getBox<List<dynamic>>(boxName: transactionBox);
    await box.put(userTransacitons, list);
  }

  // delete transactions
  Future<void> deleteTransaction() async {
    Box<List<dynamic>> box =
        await getBox<List<dynamic>>(boxName: transactionBox);
    await box.delete(userTransacitons);
  }

  // delete user data
  Future<void> deleteUser() async {
    Box<UserDataModel> box = await getBox<UserDataModel>(boxName: userBox);
    await box.delete(userData);
  }

  // get month setting list
  Future<Map<String, MonthSettingDataModel>> getMonthSettingList() async {
    DateTime time = DateTime.now();
    Box<Map<String, MonthSettingDataModel>> box =
        await getBox<Map<String, MonthSettingDataModel>>(
            boxName: monthSettingBox);
    return box.get(userMonthSetting) ??
        {
          '${time.year}-${time.month}': MonthSettingDataModel(
              budgetCat: [],
              walletInfo: [],
              budgetVal: [],
              year: time.year,
              month: time.month,
              catagory: [])
        };
  }

  // save list of month setting
  Future<void> saveMonthSetting(
      {required Map<String, MonthSettingDataModel> list}) async {
    Box<Map<String, MonthSettingDataModel>> box =
        await getBox<Map<String, MonthSettingDataModel>>(
            boxName: monthSettingBox);
    await box.put(userMonthSetting, list);
  }

  // delete month setting
  Future<void> deleteMonthSetting() async {
    Box<Map<String, MonthSettingDataModel>> box =
        await getBox<Map<String, MonthSettingDataModel>>(
            boxName: monthSettingBox);
    await box.delete(userMonthSetting);
  }
}
