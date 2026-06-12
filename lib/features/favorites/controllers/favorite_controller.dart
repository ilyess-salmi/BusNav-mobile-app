import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../models/favorite_model.dart';
import '../repositories/favorite_repository.dart';

class FavoritePlacesController extends GetxController {
  final FavoritePlacesRepository _repository = FavoritePlacesRepository();
  final AuthController _authController = Get.find<AuthController>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final favoritePlaces = <FavoritePlaceModel>[].obs;

  int get _userId => _authController.currentUser.value?.userId ?? 0;

  @override
  void onInit() {
    super.onInit();
    fetchFavoritePlaces();
  }

  Future<void> fetchFavoritePlaces() async {
    try {
      isLoading.value = true;
      favoritePlaces.value = await _repository.getFavoritePlaces();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorite places');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addFavoritePlace({
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isSaving.value = true;
      final created = await _repository.createFavoritePlace(
        userId: _userId,
        favoriteName: name,
        latitude: latitude,
        longitude: longitude,
      );
      print("-----------------------------------------");
      print(_userId);
      print("==========================================");
      favoritePlaces.add(created);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add favorite place');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateFavoritePlace({
    required int favoriteId,
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isSaving.value = true;
      final updated = await _repository.updateFavoritePlace(
        favoriteId: favoriteId,
        userId: _userId,
        favoriteName: name,
        latitude: latitude,
        longitude: longitude,
      );

      final index = favoritePlaces.indexWhere(
        (place) => place.favoriteId == favoriteId,
      );
      if (index != -1) {
        favoritePlaces[index] = updated;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite place');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteFavoritePlace(int favoriteId) async {
    try {
      await _repository.deleteFavoritePlace(favoriteId);
      favoritePlaces.removeWhere((place) => place.favoriteId == favoriteId);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete favorite place');
      return false;
    }
  }
}
