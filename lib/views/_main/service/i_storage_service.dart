abstract class IStorageService {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> removeToken();

  Future<void> saveUserPreferences(Map<String, dynamic> data);

  Future<Map<String, dynamic>?> getUserPreferences();

  Future<void> clearUserPreferences();

  Future<bool> isFirstLaunch();

  Future<void> setFirstLaunchComplete();
}
