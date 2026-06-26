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
    // user_id can come back flat (user_id: 1) or nested (user: {user_id: 1})
    final userId = json['user_id'] ??
        (json['user'] is Map ? json['user']['user_id'] : null) ??
        0;

    return FavoritePlaceModel(
      favoriteId: json['favorite_id'] as int,
      userId: userId as int,
      favoriteName: json['favorite_name'] as String,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}
