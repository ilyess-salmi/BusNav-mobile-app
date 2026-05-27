class DriverModel {
  final int driverId;
  final int userId;
  final String licenseNumber;
  final String userName;
  final String userEmail;
  final String userPhone;

  DriverModel({
    required this.driverId,
    required this.userId,
    required this.licenseNumber,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      driverId: json['driver_id'],
      userId: json['user_id'],
      licenseNumber: json['license_number'] ?? '',
      userName: json['user']?['user_name'] ?? '',
      userEmail: json['user']?['user_email'] ?? '',
      userPhone: json['user']?['user_phone'] ?? '',
    );
  }
}
