class UserModel {
  final String username;
  final String mobile;
  final String email;

  UserModel({
    required this.username,
    required this.mobile,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'mobile': mobile, 'email': email};
  }
}
