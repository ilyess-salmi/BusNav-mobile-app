class BusLocationModel {
  final int locationId;
  final int busId;
  final String plateNumber;
  final double latitude;
  final double longitude;
  final double speed;

  BusLocationModel({
    required this.locationId,
    required this.busId,
    required this.plateNumber,
    required this.latitude,
    required this.longitude,
    required this.speed,
  });

  factory BusLocationModel.fromJson(Map<String, dynamic> json) {
    return BusLocationModel(
      locationId: json['location_id'] ?? 0,
      busId: json['bus_id'] ?? json['bus']?['bus_id'] ?? 0,
      plateNumber: json['plate_number'] ?? json['bus']?['plate_number'] ?? '?',
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      speed: double.parse(json['speed'].toString()),
    );
  }
}
