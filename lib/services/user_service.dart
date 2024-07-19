import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/repositories/user_repository.dart';

class UserService {
  UserService._internal();
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserRepository _userRepository = UserRepository();

  Future<User?> login(String username, String password) async {
    Map<String, dynamic> data = {
      "username": username,
      "password": password
    };

    Map<String, dynamic> response = await _userRepository.post('/login', data);
    if (response.containsKey("user")) {
      return User.fromJson(response['user']);
    } else {
      return null;
    }
  }
}