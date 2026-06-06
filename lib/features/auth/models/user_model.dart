class UserModel {
  final int userId;
  final String userName;
  final String userEmail;
  final String role;
  final int? driverId;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.driverId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      role: json['role'] is Map // handle both cases
          ? json['role']['role_name'] ?? ''
          : json['role']?.toString() ?? '',
      driverId: json['driver_id'],
    );
  }
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'role': role,
        'driver_id': driverId,
      };
}
