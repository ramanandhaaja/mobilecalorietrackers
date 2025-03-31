class LoginResponse {
  final String token;
  final UserData user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserData {
  final String email;
  final String? username;

  UserData({required this.email, this.username});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] as String,
      username: json['username'] as String?,
    );
  }
}
