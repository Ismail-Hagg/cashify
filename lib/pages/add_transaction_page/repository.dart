import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/local_storage/local_storage.dart';
import 'package:cashify/services/firebase_service.dart';

class AddTransactionRepository {
  final LocalStorage _localStorage = LocalStorage();
  final FirebaseService _firebaseService = FirebaseService();

  // update user data locally
  Future<void> updateUserLocally({required UserDataModel user}) async {
    await _localStorage.saveUser(model: user);
  }

  // update user in backend
  Future<void> udpateUser({required UserDataModel user}) async {
    await _firebaseService.updateUsers(model: user);
  }

  // save data locally abc then in backend
  Future<void> saveAllData({required UserDataModel user}) async {
    await updateUserLocally(user: user).then((value) async {
      await udpateUser(user: user);
    });
  }
}
