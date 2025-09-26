import 'package:geolocator/geolocator.dart';

class APIConst {
  static const String apiPathV1 = '/api';
  static const String imagePath = '/assets/images/';
  static const String baseUrl = 'https://mugla-airsoft.com.tr';
  static const String baseStagingUrl = 'https://staging.mugla-airsoft.com.tr';
  static const String apiUrl = 'http://10.161.57.140:3000';
  static const String googleCom = 'https://google.com/';

  // Auth
  static const String auth = '$apiPathV1/auth';
  static const String signUp = '$auth/register';
  static const String signIn = '$auth/login';
  static const String verifyToken = '$auth/verify';
  static const String logout = '$auth/logout';

  // Character
  static const String character = '$apiPathV1/character';
  static const String updateCharacterLocation = '$character/location';
  static String getNearbyCharacters(int radius) =>
      '$character/nearby?radius=$radius';
  static const String updateCharacterStats = '$character/stats';
  static const String addItemToInventory = '$character/inventory/add';
  static const String getCharacterProfile = '$character/profile';

  // AR
  static const String ar = '$apiPathV1/ar';
  static const String autoSpawn = '$ar/auto-spawn';
  static String nearby(Position position, {int radius = 200}) =>
      '$ar/nearby?latitude=${position.latitude}&longitude=${position.longitude}&radius=$radius';
  static const String spawnTestMonster = '$ar/spawn-test-monster';
  static const String clearTestMonster = '$ar/clear-test-monsters';

  static const String personalSpawns = '$ar/personal-spawns';
  static const String proximitySpawns = '$ar/proximity-spawns';
  static const String spawnDensity = '$ar/spawn-density';
  static const String spawnBiomeMonster = '$ar/spawn-biome-monster';
}
