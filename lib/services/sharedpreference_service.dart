import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Import your User model

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;
  SharedPreferences? _prefs;

  SharedPreferencesService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUserInfo(User user) async {
    await _prefs?.setInt('id', user.id);
    await _prefs?.setString('name', user.name);
    await _prefs?.setString('username', user.username);
    await _prefs?.setString('email', user.email);
    await _prefs?.setString('avatar', user.avatar);
    await _prefs?.setBool('verified', user.verified);
    await _prefs?.setString('jwt', user.jwt);
  }

  Future<User> getUserInfo() async {
    final id = _prefs?.getInt('id');
    final name = _prefs?.getString('name');
    final username = _prefs?.getString('username');
    final email = _prefs?.getString('email');
    final avatar = _prefs?.getString('avatar');
    final jwt = _prefs?.getString('jwt');
    final verified = _prefs?.getBool('verified');

    if (id == null || name == null || username == null || email == null || avatar == null || jwt == null || verified == null) {
      return User(
          id: -1,
          name: 'Guest',
          username: 'guest',
          email: '',
          avatar: 'assets/user.jpg',
          verified: false,
          jwt: ''
      );
    }

    return User(
      id: id,
      name: name,
      username: username,
      email: email,
      avatar: avatar,
      verified: verified,
      jwt: jwt,
    );
  }

  Future<void> clearUserInfo() async {
    await _prefs?.remove('id');
    await _prefs?.remove('name');
    await _prefs?.remove('username');
    await _prefs?.remove('email');
    await _prefs?.remove('avatar');
    await _prefs?.remove('jwt');
    await _prefs?.remove('verified');
  }
}