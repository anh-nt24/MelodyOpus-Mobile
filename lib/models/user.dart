class User {
  int id;
  String name;
  String username;
  String email;
  String avatar;
  String jwt;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    required this.jwt
  });

  // use factory constructor to create a new instance of User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      jwt: json['jwt']
    );
  }

}