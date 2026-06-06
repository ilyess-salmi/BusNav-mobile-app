class DriverTripModel {
  final int tripId;
  final int busId;
  final int driverId;
  final int busLineId;
  final String tripStatus;
  final DateTime startTime;
  final DateTime? endTime;

  DriverTripModel({
    required this.tripId,
    required this.busId,
    required this.driverId,
    required this.busLineId,
    required this.tripStatus,
    required this.startTime,
    this.endTime,
  });

  factory DriverTripModel.fromJson(Map<String, dynamic> json) {
    return DriverTripModel(
      tripId: json['trip_id'],
      busId: json['bus']?['bus_id'] ?? json['bus_id'],         // handle nested object
      driverId: json['driver']?['driver_id'] ?? json['driver_id'], //handle nested object
      busLineId: json['bus']?['busLine']?['bus_line_id'] ?? 0,
      tripStatus: json['trip_status'] ?? 'started',
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'trip_id': tripId,
    'bus_id': busId,
    'driver_id': driverId,
    'trip_status': tripStatus,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
  };
}