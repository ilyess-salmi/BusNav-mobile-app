class UserModel {
  final int userId;
  final String userName;
  final String userEmail;
  final String role;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      role: json['role'],
    );
  }
}
