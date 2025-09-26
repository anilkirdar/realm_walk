import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../views/_main/model/ar_models.dart';

class CacheManager {
  static CacheManager? _instance;
  CacheManager._internal();

  factory CacheManager() {
    _instance ??= CacheManager._internal();
    return _instance!;
  }

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Cache settings
  static const Duration _defaultExpiration = Duration(hours: 1);
  static const int _maxCacheSize = 100; // Max number of cached items

  // Cache keys prefix
  static const String _keyPrefix = 'ar_cache_';
  static const String _expirationSuffix = '_exp';
  static const String _metadataKey = 'cache_metadata';

  // Cache statistics
  Map<String, int> _cacheStats = {
    'hits': 0,
    'misses': 0,
    'sets': 0,
    'evictions': 0,
  };

  // Initialize cache manager
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadCacheMetadata();
      await _cleanExpiredEntries();

      _isInitialized = true;
      print('✅ Cache manager initialized');
      return true;
    } catch (e) {
      print('❌ Cache manager initialization failed: $e');
      return false;
    }
  }

  // Set cache value with expiration
  Future<void> set<T>(String key, T value, {Duration? duration}) async {
    if (!_isInitialized) await initialize();

    try {
      final cacheKey = _keyPrefix + key;
      final expirationKey = cacheKey + _expirationSuffix;
      final expiration = DateTime.now().add(duration ?? _defaultExpiration);

      // Serialize value based on type
      String serializedValue;
      if (value is String) {
        serializedValue = value;
      } else if (value is num || value is bool) {
        serializedValue = value.toString();
      } else {
        serializedValue = json.encode(value);
      }

      // Store value and expiration
      await _prefs!.setString(cacheKey, serializedValue);
      await _prefs!.setInt(expirationKey, expiration.millisecondsSinceEpoch);

      _cacheStats['sets'] = (_cacheStats['sets'] ?? 0) + 1;

      // Manage cache size
      await _manageCacheSize();

      print('💾 Cached: $key (expires: ${expiration.toIso8601String()})');
    } catch (e) {
      print('❌ Failed to cache $key: $e');
    }
  }

  // Get cache value
  Future<T?> get<T>(String key) async {
    if (!_isInitialized) await initialize();

    try {
      final cacheKey = _keyPrefix + key;
      final expirationKey = cacheKey + _expirationSuffix;

      // Check if key exists
      if (!_prefs!.containsKey(cacheKey)) {
        _cacheStats['misses'] = (_cacheStats['misses'] ?? 0) + 1;
        return null;
      }

      // Check expiration
      final expirationMs = _prefs!.getInt(expirationKey);
      if (expirationMs != null) {
        final expiration = DateTime.fromMillisecondsSinceEpoch(expirationMs);
        if (DateTime.now().isAfter(expiration)) {
          await _removeKey(key);
          _cacheStats['misses'] = (_cacheStats['misses'] ?? 0) + 1;
          return null;
        }
      }

      // Get and deserialize value
      final serializedValue = _prefs!.getString(cacheKey);
      if (serializedValue == null) {
        _cacheStats['misses'] = (_cacheStats['misses'] ?? 0) + 1;
        return null;
      }

      _cacheStats['hits'] = (_cacheStats['hits'] ?? 0) + 1;

      // Deserialize based on expected type
      if (T == String) {
        return serializedValue as T;
      } else if (T == int) {
        return int.tryParse(serializedValue) as T?;
      } else if (T == double) {
        return double.tryParse(serializedValue) as T?;
      } else if (T == bool) {
        return (serializedValue.toLowerCase() == 'true') as T;
      } else {
        // Assume JSON for complex types
        final decoded = json.decode(serializedValue);
        return decoded as T;
      }
    } catch (e) {
      print('❌ Failed to get cached $key: $e');
      _cacheStats['misses'] = (_cacheStats['misses'] ?? 0) + 1;
      return null;
    }
  }

  // Check if key exists and is not expired
  Future<bool> contains(String key) async {
    if (!_isInitialized) await initialize();

    final cacheKey = _keyPrefix + key;
    final expirationKey = cacheKey + _expirationSuffix;

    if (!_prefs!.containsKey(cacheKey)) return false;

    // Check expiration
    final expirationMs = _prefs!.getInt(expirationKey);
    if (expirationMs != null) {
      final expiration = DateTime.fromMillisecondsSinceEpoch(expirationMs);
      if (DateTime.now().isAfter(expiration)) {
        await _removeKey(key);
        return false;
      }
    }

    return true;
  }

  // Remove specific key
  Future<void> remove(String key) async {
    if (!_isInitialized) await initialize();
    await _removeKey(key);
  }

  // Remove key implementation
  Future<void> _removeKey(String key) async {
    final cacheKey = _keyPrefix + key;
    final expirationKey = cacheKey + _expirationSuffix;

    await _prefs!.remove(cacheKey);
    await _prefs!.remove(expirationKey);
  }

  // Clear all cache
  Future<void> clear() async {
    if (!_isInitialized) await initialize();

    final keys = _prefs!
        .getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .toList();

    for (final key in keys) {
      await _prefs!.remove(key);
    }

    _cacheStats.clear();
    print('🧹 Cache cleared');
  }

  // Clean expired entries
  Future<void> _cleanExpiredEntries() async {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    final allKeys = _prefs!.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(_keyPrefix) && key.endsWith(_expirationSuffix)) {
        final expirationMs = _prefs!.getInt(key);
        if (expirationMs != null) {
          final expiration = DateTime.fromMillisecondsSinceEpoch(expirationMs);
          if (now.isAfter(expiration)) {
            final dataKey = key.replaceAll(_expirationSuffix, '');
            keysToRemove.addAll([key, dataKey]);
          }
        }
      }
    }

    for (final key in keysToRemove) {
      await _prefs!.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      print('🗑️ Cleaned ${keysToRemove.length / 2} expired cache entries');
    }
  }

  // Manage cache size by removing oldest entries
  Future<void> _manageCacheSize() async {
    final dataKeys = _prefs!
        .getKeys()
        .where(
          (key) =>
              key.startsWith(_keyPrefix) && !key.endsWith(_expirationSuffix),
        )
        .toList();

    if (dataKeys.length <= _maxCacheSize) return;

    // Get entries with their expiration times
    final entries = <MapEntry<String, int>>[];

    for (final key in dataKeys) {
      final expirationKey = key + _expirationSuffix;
      final expirationMs = _prefs!.getInt(expirationKey);
      if (expirationMs != null) {
        entries.add(MapEntry(key, expirationMs));
      }
    }

    // Sort by expiration time (oldest first)
    entries.sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest entries
    final entriesToRemove = entries.take(entries.length - _maxCacheSize);
    for (final entry in entriesToRemove) {
      await _prefs!.remove(entry.key);
      await _prefs!.remove(entry.key + _expirationSuffix);
      _cacheStats['evictions'] = (_cacheStats['evictions'] ?? 0) + 1;
    }

    print('🗑️ Evicted ${entriesToRemove.length} cache entries to manage size');
  }

  // Load cache metadata
  Future<void> _loadCacheMetadata() async {
    try {
      final metadata = _prefs!.getString(_metadataKey);
      if (metadata != null) {
        final decoded = json.decode(metadata) as Map<String, dynamic>;
        _cacheStats = decoded.cast<String, int>();
      }
    } catch (e) {
      print('⚠️ Failed to load cache metadata: $e');
    }
  }

  // Save cache metadata
  Future<void> _saveCacheMetadata() async {
    try {
      await _prefs!.setString(_metadataKey, json.encode(_cacheStats));
    } catch (e) {
      print('⚠️ Failed to save cache metadata: $e');
    }
  }

  // Get cache statistics
  Map<String, dynamic> getStats() {
    final totalRequests =
        (_cacheStats['hits'] ?? 0) + (_cacheStats['misses'] ?? 0);
    final hitRatio = totalRequests > 0
        ? (_cacheStats['hits'] ?? 0) / totalRequests
        : 0.0;

    final dataKeys =
        _prefs
            ?.getKeys()
            .where(
              (key) =>
                  key.startsWith(_keyPrefix) &&
                  !key.endsWith(_expirationSuffix),
            )
            .length ??
        0;

    return {
      'hits': _cacheStats['hits'] ?? 0,
      'misses': _cacheStats['misses'] ?? 0,
      'sets': _cacheStats['sets'] ?? 0,
      'evictions': _cacheStats['evictions'] ?? 0,
      'hitRatio': (hitRatio * 100).toStringAsFixed(1) + '%',
      'totalEntries': dataKeys,
      'maxSize': _maxCacheSize,
      'isInitialized': _isInitialized,
    };
  }

  // Get cache size in bytes (approximate)
  int getCacheSizeBytes() {
    if (!_isInitialized) return 0;

    int totalSize = 0;
    final allKeys = _prefs!.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(_keyPrefix)) {
        final value = _prefs!.getString(key);
        if (value != null) {
          totalSize += key.length + value.length;
        }
      }
    }

    return totalSize;
  }

  // Get human readable cache size
  String getCacheSizeFormatted() {
    final bytes = getCacheSizeBytes();

    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  // Cache-specific methods for AR data

  // Cache AR objects with location-based key
  Future<void> cacheARObjects(
    Position position,
    List<ARMonster> monsters,
    List<ARResource> resources, {
    Duration? duration,
  }) async {
    final key =
        'ar_objects_${position.latitude.toStringAsFixed(4)}_${position.longitude.toStringAsFixed(4)}';

    await set(key, {
      'monsters': monsters.map((m) => m.toJson()).toList(),
      'resources': resources.map((r) => r.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    }, duration: duration ?? Duration(minutes: 5));
  }

  // Get cached AR objects
  Future<Map<String, dynamic>?> getCachedARObjects(Position position) async {
    final key =
        'ar_objects_${position.latitude.toStringAsFixed(4)}_${position.longitude.toStringAsFixed(4)}';
    return await get<Map<String, dynamic>>(key);
  }

  // Cache personal spawns
  Future<void> cachePersonalSpawns(
    String playerId,
    List<ARMonster> monsters, {
    Duration? duration,
  }) async {
    final key = 'personal_spawns_$playerId';

    await set(key, {
      'monsters': monsters.map((m) => m.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    }, duration: duration ?? Duration(minutes: 10));
  }

  // Get cached personal spawns
  Future<List<ARMonster>?> getCachedPersonalSpawns(String playerId) async {
    final key = 'personal_spawns_$playerId';
    final data = await get<Map<String, dynamic>>(key);

    if (data != null && data['monsters'] != null) {
      return (data['monsters'] as List)
          .map((json) => ARMonster.fromJson(json))
          .toList();
    }

    return null;
  }

  // Cache nearby players
  Future<void> cacheNearbyPlayers(
    Position position,
    List<NearbyPlayer> players, {
    Duration? duration,
  }) async {
    final key =
        'nearby_players_${position.latitude.toStringAsFixed(4)}_${position.longitude.toStringAsFixed(4)}';

    await set(key, {
      'players': players.map((p) => p.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    }, duration: duration ?? Duration(minutes: 2));
  }

  // Debug methods
  void logCacheContents() {
    if (!_isInitialized) return;

    print('=== Cache Contents ===');
    final allKeys = _prefs!
        .getKeys()
        .where(
          (key) =>
              key.startsWith(_keyPrefix) && !key.endsWith(_expirationSuffix),
        )
        .toList();

    for (final key in allKeys) {
      final expirationKey = key + _expirationSuffix;
      final expirationMs = _prefs!.getInt(expirationKey);
      final expiration = expirationMs != null
          ? DateTime.fromMillisecondsSinceEpoch(expirationMs)
          : null;

      final value = _prefs!.getString(key);
      print('Key: ${key.replaceFirst(_keyPrefix, '')}');
      print('  Expires: ${expiration?.toIso8601String() ?? 'Never'}');
      print('  Size: ${value?.length ?? 0} chars');
      print(
        '  Valid: ${expiration == null || DateTime.now().isBefore(expiration)}',
      );
    }

    print('Total entries: ${allKeys.length}');
    print('Cache size: ${getCacheSizeFormatted()}');
    print('Statistics: ${getStats()}');
    print('=====================');
  }

  // Dispose and cleanup
  Future<void> dispose() async {
    await _saveCacheMetadata();
    _cacheStats.clear();
    print('🧹 Cache manager disposed');
  }
}
