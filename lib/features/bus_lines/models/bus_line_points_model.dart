class BusLinePointsModel {
  final int point_id;
  final int bus_line_id;
  final int point_order;
  final double latitude;
  final double longitude;
 
  BusLinePointsModel({
    required this.point_id,
    required this.bus_line_id,
    required this.point_order,
    required this.latitude,
    required this.longitude,
  });

  factory BusLinePointsModel.fromJson(Map<String, dynamic> json) {
    return BusLinePointsModel(
      point_id: json['point_id'],
      bus_line_id: json['bus_line_id'],
      point_order: json['point_order'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}