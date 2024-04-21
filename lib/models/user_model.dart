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
      required this.isError});

  toMap() {
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
      'isError': isError
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
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
    );
  }
}
