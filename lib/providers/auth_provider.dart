import 'package:flutter/cupertino.dart';
import 'package:melodyopus/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  AuthProvider() {
    _user = User(
      id: -1,
      name: 'Guest',
      username: 'guest',
      email: '',
      avatar: 'assets/user.jpg',
      verified: false,
      jwt: ''
    );
  }

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  User? getUser() => _user;



}