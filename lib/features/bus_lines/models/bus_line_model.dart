class BusLineModel {
  final int busLineId;
  final String lineName;
  final String startPoint;
  final String endPoint;

  BusLineModel({
    required this.busLineId,
    required this.lineName,
    required this.startPoint,
    required this.endPoint,
  });

  factory BusLineModel.fromJson(Map<String, dynamic> json) {
    return BusLineModel(
      busLineId: json['bus_line_id'],
      lineName: json['line_name'],
      startPoint: json['start_point'],
      endPoint: json['end_point'],
    );
  }
}
