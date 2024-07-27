import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/repositories/user_repository.dart';

class UserService {
  UserService._internal();
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  UserRepository _userRepository = UserRepository();

  Future<User> login(String username, String password) async {
    try {
      return await _userRepository.login(username, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String name, String email, String username, String password) async {
    try {
      await _userRepository.signup(name, email, username, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> signInGoogle(String? idToken) async {
    try {
      if (idToken == null) {
        throw Exception("Token can't be null");
      }
      return await _userRepository.signInGoogle(idToken);
    } catch (e) {
      rethrow;
    }
  }
}