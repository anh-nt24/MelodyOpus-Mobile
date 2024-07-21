class User {
  int id;
  String name;
  String username;
  String email;
  String avatar;
  bool verified;
  String jwt;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    required this.verified,
    required this.jwt
  });

  // use factory constructor to create a new instance of User
  factory User.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return User(
      id: userJson['id'],
      name: userJson['name'],
      username: userJson['username'],
      email: userJson['email'],
      avatar: userJson['avatar'] == null ? _getInitials(userJson['name']) : userJson['avatar'],
      verified: userJson['verified'],
      jwt: json['jwt'],
    );
  }

  static String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return '${names.first[0]}${names.first[1]}'.toUpperCase();
  }

}