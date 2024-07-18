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
      jwt: ''
    );
  }

  User? getUser() => _user;



}