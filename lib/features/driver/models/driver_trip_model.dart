class DriverTripModel {
  final int tripId;
  final int busId;
  final int driverId;
  final String tripStatus;
  final DateTime startTime;
  final DateTime? endTime;

  DriverTripModel({
    required this.tripId,
    required this.busId,
    required this.driverId,
    required this.tripStatus,
    required this.startTime,
    this.endTime,
  });

  factory DriverTripModel.fromJson(Map<String, dynamic> json) {
    return DriverTripModel(
      tripId: json['trip_id'],
      busId: json['bus_id'],
      driverId: json['driver_id'],
      tripStatus: json['trip_status'] ?? 'started',
      startTime: DateTime.parse(json['start_time']),
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
    );
  }
}
