class BusLocationModel {
  final int locationId;
  final int busId;
  final double latitude;
  final double longitude;
  final double speed;

  BusLocationModel({
    required this.locationId,
    required this.busId,
    required this.latitude,
    required this.longitude,
    required this.speed,
  });

  factory BusLocationModel.fromJson(Map<String, dynamic> json) {
    return BusLocationModel(
      locationId: json['location_id'],
      busId: json['bus']?['bus_id'] ?? json['bus_id'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      speed: double.parse(json['speed'].toString()),
    );
  }
}
