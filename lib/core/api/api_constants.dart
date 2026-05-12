class ApiConstants {
  static const bool isEmulator = false; //for both cases

  static const String baseUrl = isEmulator
    ? 'http://10.0.2.2:3003'
    : 'http://192.168.11.125:3003';
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Main user features
  static const String busLines = '/bus-lines';
  static const String busStops = '/bus-stops';
  static const String predictions = '/predictions';
  static const String notifications = '/notifications';
  static const String favoritePlaces = '/favorite-places';

  // Driver features
  static const String trips = '/trips';
  static const String busLocations = '/bus-locations';

  // Admin features
  static const String users = '/users';
  static const String roles = '/roles';
  static const String buses = '/buses';
  static const String service = '/service';
  static const String passes = '/passes';
}
