import '../../../core/api/api_client.dart';
import '../models/favorite_model.dart';

class FavoritePlacesRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<FavoritePlaceModel>> getFavoritePlaces() async {
    final response = await _apiClient.get('/favorite-places');

    return (response.data as List)
        .map((json) => FavoritePlaceModel.fromJson(json))
        .toList();
  }

  Future<FavoritePlaceModel> createFavoritePlace({
    required int userId,
    required String favoriteName,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.post('/favorite-places', {
      'user_id': userId,
      'favorite_name': favoriteName,
      'latitude': latitude,
      'longitude': longitude,
    });

    return FavoritePlaceModel.fromJson(response.data);
  }

  Future<FavoritePlaceModel> updateFavoritePlace({
    required int favoriteId,
    required int userId,
    required String favoriteName,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.patch('/favorite-places/$favoriteId', {
      'user_id': userId,
      'favorite_name': favoriteName,
      'latitude': latitude,
      'longitude': longitude,
    });

    return FavoritePlaceModel.fromJson(response.data);
  }

  Future<void> deleteFavoritePlace(int favoriteId) async {
    await _apiClient.delete('/favorite-places/$favoriteId');
  }
}
