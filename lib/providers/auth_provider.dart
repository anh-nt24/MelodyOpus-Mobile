import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/services/sharedpreference_service.dart';

class AuthProvider with ChangeNotifier {
  User _user = User.guest();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  User get user => _user;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await _prefsService.getUser();
    notifyListeners();
  }

  Future<void> login(User user) async {
    _user = user;
    await _prefsService.saveUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = User.guest();
    await _prefsService.clearUser();
    notifyListeners();
  }
}
