import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../home/widgets/home_bottom_nav.dart';
import '../controllers/favorite_controller.dart';
import '../models/favorite_model.dart';
import '../widgets/favorite_place_card.dart';
import 'pick_location_screen.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({super.key});

  Future<void> _openAddDialog(BuildContext context) async {
    final controller = Get.find<FavoritePlacesController>();
    final nameController = TextEditingController();
    LatLng? pickedLocation;

    await _showFavoritePlaceDialog(
      context: context,
      title: 'Add Favorite Place',
      nameController: nameController,
      initialLocation: null,
      onLocationPicked: (location) => pickedLocation = location,
      onSave: () async {
        if (nameController.text.trim().isEmpty || pickedLocation == null) {
          Get.snackbar(
              'Missing info', 'Please enter a name and pick a location');
          return false;
        }
        return controller.addFavoritePlace(
          name: nameController.text.trim(),
          latitude: pickedLocation!.latitude,
          longitude: pickedLocation!.longitude,
        );
      },
    );
  }

  Future<void> _openEditDialog(
    BuildContext context,
    FavoritePlaceModel place,
  ) async {
    final controller = Get.find<FavoritePlacesController>();
    final nameController = TextEditingController(text: place.favoriteName);
    LatLng? pickedLocation = LatLng(place.latitude, place.longitude);

    await _showFavoritePlaceDialog(
      context: context,
      title: 'Edit Favorite Place',
      nameController: nameController,
      initialLocation: pickedLocation,
      onLocationPicked: (location) => pickedLocation = location,
      onSave: () async {
        if (nameController.text.trim().isEmpty || pickedLocation == null) {
          Get.snackbar(
              'Missing info', 'Please enter a name and pick a location');
          return false;
        }
        return controller.updateFavoritePlace(
          favoriteId: place.favoriteId,
          name: nameController.text.trim(),
          latitude: pickedLocation!.latitude,
          longitude: pickedLocation!.longitude,
        );
      },
    );
  }

  Future<void> _showFavoritePlaceDialog({
    required BuildContext context,
    required String title,
    required TextEditingController nameController,
    required LatLng? initialLocation,
    required ValueChanged<LatLng> onLocationPicked,
    required Future<bool> Function() onSave,
  }) async {
    LatLng? currentLocation = initialLocation;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Home, Work',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.of(context).push<LatLng>(
                        MaterialPageRoute(
                          builder: (_) => PickLocationScreen(
                            initialLatitude: currentLocation?.latitude,
                            initialLongitude: currentLocation?.longitude,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          currentLocation = result;
                        });
                        onLocationPicked(result);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E2FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFB247FF),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentLocation == null
                                  ? 'Pick location on map'
                                  : '${currentLocation!.latitude.toStringAsFixed(5)}, '
                                      '${currentLocation!.longitude.toStringAsFixed(5)}',
                              style: const TextStyle(
                                color: Color(0xFFB247FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB247FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final success = await onSave();
                    if (success && dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FavoritePlaceModel place) {
    final controller = Get.find<FavoritePlacesController>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Favorite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Remove "${place.favoriteName}" from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.deleteFavoritePlace(place.favoriteId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritePlacesController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FD),
      bottomNavigationBar: const HomeBottomNav(activeIndex: 2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB247FF),
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB247FF),
                      ),
                    );
                  }

                  if (controller.favoritePlaces.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: Colors.black26,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No favorite places yet',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap + to add one',
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFFB247FF),
                    onRefresh: controller.fetchFavoritePlaces,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: controller.favoritePlaces.length,
                      itemBuilder: (context, index) {
                        final place = controller.favoritePlaces[index];
                        return FavoritePlaceCard(
                          name: place.favoriteName,
                          latitude: place.latitude,
                          longitude: place.longitude,
                          onEdit: () => _openEditDialog(context, place),
                          onDelete: () => _confirmDelete(context, place),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
