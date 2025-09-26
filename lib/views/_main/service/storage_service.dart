// import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'i_storage_service.dart';

// class StorageService extends IStorageService {
//   StorageService._init();
//   static StorageService? _instance;
//   static StorageService? get instance {
//     _instance ??= StorageService._init();
//     return _instance;
//   }

//   static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

//   // Token operations (secure)
//   @override
//   Future<void> saveToken(String token) async {
//     await _secureStorage.write(key: 'auth_token', value: token);
//   }

//   @override
//   Future<String> getToken() async {
//     return await _secureStorage.read(key: 'auth_token') ?? '';
//   }

//   @override
//   Future<void> removeToken() async {
//     await _secureStorage.delete(key: 'auth_token');
//   }

//   // User preferences (non-sensitive)
//   @override
//   Future<void> saveUserPreferences(Map<String, dynamic> data) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('user_data', jsonEncode(data));
//   }

//   @override
//   Future<Map<String, dynamic>?> getUserPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userData = prefs.getString('user_data');
//     if (userData != null) {
//       return jsonDecode(userData);
//     }
//     return null;
//   }

//   @override
//   Future<void> clearUserPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user_data');
//   }

//   // First time app launch
//   @override
//   Future<bool> isFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('first_launch') ?? true;
//   }

//   @override
//   Future<void> setFirstLaunchComplete() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('first_launch', false);
//   }
// }
