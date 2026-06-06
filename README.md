# BusNav — Flutter Mobile App

A real-time bus navigation mobile app built with **Flutter** and **GetX**, connecting to the BusNav NestJS backend.

---

## Tech Stack

- **Flutter** — cross-platform mobile framework
- **GetX** — state management, routing, and dependency injection
- **Dio** — HTTP client (via custom `ApiClient`)
- **GetStorage** — local JWT and user data storage
- **google_maps_flutter** — map display (user home map + driver map)
- **flutter_map** / **latlong2** — additional map utilities
- **geolocator** — GPS location for driver tracking
- **SSE (dart:convert + http)** — real-time bus location stream

---

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter | >= 3.x |
| Dart | >= 3.x |
| Android Studio / Xcode | Latest stable |
| A running BusNav backend | See backend README |

---

## Installation

```bash
# Clone the repository
git clone <repo-url>
cd busnav-flutter

# Install dependencies
flutter pub get
```

---

## Configuration

### Backend URL

The base URL is set in:

```
lib/core/api/api_constants.dart
```

Update it based on your environment:

| Environment | URL |
|-------------|-----|
| Android emulator | `http://10.0.2.2:3003` |
| iOS simulator | `http://localhost:3003` |
| Physical device | `http://<your-machine-local-ip>:3003` |

### Google Maps API Key

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

**iOS** — `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

---

## Running the App

```bash
# Run on a connected device or emulator
flutter run

# Run on a specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

---

## Project Structure

```
lib/
  core/
    api/
      api_client.dart         – Dio client with JWT interceptor
      api_constants.dart      – base URL config
    storage/
      token_storage.dart      – JWT + role + guest mode storage

  features/
    auth/
      controllers/
        auth_controller.dart  – login, register, guest, logout, profile
      models/
        user_model.dart
      repositories/
        auth_repository.dart

    home/
      screens/
        home_screen.dart
      widgets/
        home_map.dart         – flutter_map with bus markers + route polyline
        home_header.dart
        home_search_bar.dart
        home_bottom_nav.dart
        home_nav_item.dart
        nearby_bus_sheet.dart

    bus_lines/
      bindings/
      controllers/
        bus_lines_controller.dart
        selected_bus_line_controller.dart
        get_line_points_controller.dart
      models/
        bus_line_model.dart
        bus_line_points_model.dart
      repositories/
        bus_lines_repository.dart
      screens/
        bus_lines_screen.dart
      widgets/
        bus_line_card.dart

    bus_locations/
      controllers/
        bus_locations_controller.dart  – SSE connection, real-time markers
      models/
        bus_location_model.dart

    driver/
      bindings/
        driver_home_binding.dart
        driver_trip_binding.dart
        driver_profile_binding.dart
      controllers/
        driver_home_controller.dart
        driver_trip_controller.dart       – fetch trips, start/end trip
        driver_location_controller.dart   – GPS polling → POST /bus-locations
        driver_profile_controller.dart
      models/
        driver_model.dart
        driver_trip_model.dart
      repositories/
        driver_trip_repository.dart
        driver_location_repository.dart
      screens/
        driver_home_screen.dart
        driver_trip_screen.dart
        driver_trip_detail_screen.dart    – map + polyline + start/end
        driver_profile_screen.dart
        driver_report_problem_screen.dart
      widgets/
        driver_bottom_nav.dart
        driver_map.dart
        trip_status_card.dart
        report_problem_form.dart

  routes/
    app_routes.dart
    app_pages.dart
```

---

## App Flows

### Authentication

1. User opens app → `AuthController` checks stored token
2. If token exists → redirect to `/home` (user) or `/driver/home` (driver)
3. If no token → redirect to `/login`
4. Guest mode available → skips auth, goes to `/home`

### Role-Based Redirect

After login, the role in the JWT response determines the destination:

| Role | Redirect |
|------|----------|
| `user` | `/home` |
| `driver` | `/driver/home` |
| guest | `/home` |

### Real-Time Bus Locations (User)

```
HomeScreen mounts
  → BusLocationsController.onInit()
    → connects to GET /bus-locations/stream (SSE)
      → each event updates busLocations map (busId → location)
        → Obx rebuilds MarkerLayer on HomeMap
```

### Driver GPS Tracking

```
Driver taps Start Trip
  → PATCH /trips/:id { trip_status: 'in_progress' }
  → DriverLocationController.startTracking(busId)
    → Geolocator polls every 5 seconds
      → POST /bus-locations { bus_id, lat, lng, speed }
        → Backend SSE broadcasts to all passengers

Driver taps End Trip
  → PATCH /trips/:id { trip_status: 'finished', end_time }
  → DriverLocationController.stopTracking()
```

---

## Routes

| Route | Screen |
|-------|--------|
| `/login` | Login screen |
| `/register` | Register screen |
| `/home` | Home screen (user map) |
| `/bus-lines` | Bus lines list |
| `/driver/home` | Driver home (map) |
| `/driver/trip` | Driver trips list |
| `/driver/trip/detail` | Trip detail + polyline |
| `/driver/profile` | Driver profile |
| `/driver/report` | Report problem |

---

## Key Packages (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.x
  dio: ^5.x
  get_storage: ^2.x
  google_maps_flutter: ^2.x
  flutter_map: ^6.x
  latlong2: ^0.x
  geolocator: ^11.x
  http: ^1.x
```

---

## Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>BusNav needs your location to track your route.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>BusNav needs your location to continue tracking in the background.</string>
```

---

## Trip Status Values

| Value | Meaning |
|-------|---------|
| `started` | Trip assigned, not yet active |
| `in_progress` | Driver started, GPS tracking active |
| `finished` | Trip completed, GPS stopped |

---

## Notes

- The `AuthController` is registered permanently in `InitialBinding` so it persists across all screens.
- `driver_id` is returned in the login response for driver users and stored in `UserModel`.
- The `DriverTripController` uses `driverId` from `AuthController` to call `GET /trips?driver_id=X`.
- SSE reconnects automatically after 3 seconds on disconnect or error.