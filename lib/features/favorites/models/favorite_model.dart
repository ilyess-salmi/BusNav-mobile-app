class FavoritePlaceModel {
  final int favoriteId;
  final int userId;
  final String favoriteName;
  final double latitude;
  final double longitude;

  FavoritePlaceModel({
    required this.favoriteId,
    required this.userId,
    required this.favoriteName,
    required this.latitude,
    required this.longitude,
  });

  factory FavoritePlaceModel.fromJson(Map<String, dynamic> json) {
    return FavoritePlaceModel(
      favoriteId: json['favorite_id'],
      userId: json['user_id'] is Map
          ? json['user_id']['user_id'] ?? 0
          : (json['user_id'] ?? 0),
      favoriteName: json['favorite_name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'favorite_name': favoriteName,
        'latitude': latitude,
        'longitude': longitude,
      };
}
