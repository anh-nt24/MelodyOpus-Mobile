import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/services/user_service.dart';

class UserRepository {
  UserService _userService = UserService.userInstance;

  Future<User?> login(String email, String password) async {
    Map<String, dynamic> data = {
      "email": email,
      "password": password
    };

    Map<String, dynamic> response = await _userService.post('/login', data);
    if (response.containsKey("user")) {
      return User.fromJson(response['user']);
    } else {
      return null;
    }
  }
}