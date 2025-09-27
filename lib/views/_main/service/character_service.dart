import 'package:vexana/vexana.dart';

import '../../../../core/base/service/base_service.dart';
import '../model/character_model.dart';
import '../model/character_stats_model.dart';
import '../model/character_update_response.dart';
import '../model/nearby_character_model.dart';
import 'i_character_service.dart';

enum _CharacterAPI {
  character('/character/{characterId}'),
  createCharacter('/character'),
  updateCharacter('/character/{characterId}'),
  deleteCharacter('/character/{characterId}'),
  characterStats('/character/{characterId}/stats'),
  updateStats('/character/{characterId}/stats'),
  updateLocation('/character/location'),
  nearbyCharacters('/character/nearby'),
  gainExperience('/character/{characterId}/experience'),
  levelUp('/character/{characterId}/level-up'),
  updateSkill('/character/{characterId}/skill'),
  updateAppearance('/character/{characterId}/appearance'),
  updateEquipment('/character/{characterId}/equipment'),
  setOnlineStatus('/character/{characterId}/status/online'),
  setActivityStatus('/character/{characterId}/status/activity'),
  sendFriendRequest('/character/friends/request'),
  acceptFriendRequest('/character/friends/accept/{requestId}'),
  rejectFriendRequest('/character/friends/reject/{requestId}'),
  getFriends('/character/{characterId}/friends'),
  searchCharacters('/character/search'),
  getCharacterByUsername('/character/username/{username}');

  const _CharacterAPI(this.apiPath);
  final String apiPath;

  String withId(String id) => apiPath.replaceAll(RegExp(r'\{.*?\}'), id);
  String withParams(Map<String, String> params) {
    String path = apiPath;
    params.forEach((key, value) {
      path = path.replaceAll('{$key}', value);
    });
    return path;
  }
}

class CharacterService extends ICharacterService with BaseService {
  CharacterService(super.manager);

  @override
  Future<CharacterModel?> getCharacterInfo(String characterId) async {
    try {
      printDev.debug(
        'CharacterService: Getting character info for $characterId',
      );

      final response = await manager.send<CharacterModel, CharacterModel>(
        _CharacterAPI.character.withId(characterId),
        parseModel: CharacterModel(),
        method: RequestType.GET,
      );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Get character error - ${response.error}',
        );
        await crashlyticsManager.sendACrash(
          error: response.error.toString(),
          stackTrace: StackTrace.current,
          reason: 'Get Character Error',
        );
        return null;
      }

      printDev.debug('CharacterService: Character info retrieved successfully');
      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Get character exception - $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Get Character Exception',
      );
      return null;
    }
  }

  @override
  Future<CharacterModel?> createCharacter(CharacterModel character) async {
    try {
      printDev.debug('CharacterService: Creating character ${character.name}');

      final response = await manager.send<CharacterModel, CharacterModel>(
        _CharacterAPI.createCharacter.apiPath,
        parseModel: CharacterModel(),
        method: RequestType.POST,
        data: character.toJson(),
      );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Create character error - ${response.error}',
        );
        return null;
      }

      printDev.debug('CharacterService: Character created successfully');
      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Create character exception - $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Create Character Exception',
      );
      return null;
    }
  }

  @override
  Future<CharacterModel?> updateCharacter(
    String characterId,
    Map<String, dynamic> updates,
  ) async {
    try {
      printDev.debug('CharacterService: Updating character $characterId');

      final response = await manager.send<CharacterModel, CharacterModel>(
        _CharacterAPI.updateCharacter.withId(characterId),
        parseModel: CharacterModel(),
        method: RequestType.PUT,
        data: updates,
      );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Update character error - ${response.error}',
        );
        return null;
      }

      printDev.debug('CharacterService: Character updated successfully');
      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Update character exception - $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Update Character Exception',
      );
      return null;
    }
  }

  @override
  Future<bool> deleteCharacter(String characterId) async {
    try {
      printDev.debug('CharacterService: Deleting character $characterId');

      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.deleteCharacter.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.DELETE,
      );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Delete character error - ${response.error}',
        );
        return false;
      }

      printDev.debug('CharacterService: Character deleted successfully');
      return true;
    } catch (e) {
      printDev.exception('CharacterService: Delete character exception - $e');
      return false;
    }
  }

  @override
  Future<CharacterStatsModel?> getCharacterStats(String characterId) async {
    try {
      final response = await manager
          .send<CharacterStatsModel, CharacterStatsModel>(
            _CharacterAPI.characterStats.withId(characterId),
            parseModel: CharacterStatsModel(),
            method: RequestType.GET,
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Get stats error - ${response.error}',
        );
        return null;
      }

      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Get stats exception - $e');
      return null;
    }
  }

  @override
  Future<CharacterStatsModel?> updateCharacterStats(
    String characterId,
    CharacterStatsModel stats,
  ) async {
    try {
      final response = await manager
          .send<CharacterStatsModel, CharacterStatsModel>(
            _CharacterAPI.updateStats.withId(characterId),
            parseModel: CharacterStatsModel(),
            method: RequestType.PUT,
            data: stats.toJson(),
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Update stats error - ${response.error}',
        );
        return null;
      }

      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Update stats exception - $e');
      return null;
    }
  }

  @override
  Future<CharacterUpdateResponse?> updateLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      printDev.debug(
        'CharacterService: Updating location to $latitude, $longitude',
      );

      final response = await manager
          .send<CharacterUpdateResponse, CharacterUpdateResponse>(
            _CharacterAPI.updateLocation.apiPath,
            parseModel: CharacterUpdateResponse(),
            method: RequestType.POST,
            data: {
              'latitude': latitude,
              'longitude': longitude,
              'timestamp': DateTime.now().toIso8601String(),
            },
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Update location error - ${response.error}',
        );
        return null;
      }

      return response.data;
    } catch (e) {
      printDev.exception('CharacterService: Update location exception - $e');
      return null;
    }
  }

  @override
  Future<List<NearbyCharacter>> getNearbyCharacters(
    double latitude,
    double longitude, {
    int radius = 500,
  }) async {
    try {
      printDev.debug('CharacterService: Getting nearby characters');

      final response = await manager
          .send<List<NearbyCharacter>, List<NearbyCharacter>>(
            _CharacterAPI.nearbyCharacters.apiPath,
            parseModel: <NearbyCharacter>[],
            method: RequestType.GET,
            queryParameters: {
              'latitude': latitude.toString(),
              'longitude': longitude.toString(),
              'radius': radius.toString(),
            },
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Get nearby characters error - ${response.error}',
        );
        return [];
      }

      return response.data ?? [];
    } catch (e) {
      printDev.exception(
        'CharacterService: Get nearby characters exception - $e',
      );
      return [];
    }
  }

  @override
  Future<bool> gainExperience(String characterId, int experience) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.gainExperience.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {'experience': experience},
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Gain experience exception - $e');
      return false;
    }
  }

  @override
  Future<bool> levelUp(String characterId) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.levelUp.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Level up exception - $e');
      return false;
    }
  }

  @override
  Future<bool> updateSkill(
    String characterId,
    String skillId,
    int newLevel,
  ) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.updateSkill.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.PUT,
        data: {'skillId': skillId, 'newLevel': newLevel},
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Update skill exception - $e');
      return false;
    }
  }

  @override
  Future<bool> updateAppearance(
    String characterId,
    Map<String, dynamic> appearance,
  ) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.updateAppearance.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.PUT,
        data: appearance,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Update appearance exception - $e');
      return false;
    }
  }

  @override
  Future<bool> updateEquipment(
    String characterId,
    Map<String, dynamic> equipment,
  ) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.updateEquipment.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.PUT,
        data: equipment,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Update equipment exception - $e');
      return false;
    }
  }

  @override
  Future<bool> setOnlineStatus(String characterId, bool isOnline) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.setOnlineStatus.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {'isOnline': isOnline},
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('CharacterService: Set online status exception - $e');
      return false;
    }
  }

  @override
  Future<bool> setActivityStatus(String characterId, String activity) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.setActivityStatus.withId(characterId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {'activity': activity},
      );

      return response.error == null;
    } catch (e) {
      printDev.exception(
        'CharacterService: Set activity status exception - $e',
      );
      return false;
    }
  }

  @override
  Future<bool> sendFriendRequest(
    String fromCharacterId,
    String toCharacterId,
  ) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.sendFriendRequest.apiPath,
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {
          'fromCharacterId': fromCharacterId,
          'toCharacterId': toCharacterId,
        },
      );

      return response.error == null;
    } catch (e) {
      printDev.exception(
        'CharacterService: Send friend request exception - $e',
      );
      return false;
    }
  }

  @override
  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.acceptFriendRequest.withId(requestId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception(
        'CharacterService: Accept friend request exception - $e',
      );
      return false;
    }
  }

  @override
  Future<bool> rejectFriendRequest(String requestId) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _CharacterAPI.rejectFriendRequest.withId(requestId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception(
        'CharacterService: Reject friend request exception - $e',
      );
      return false;
    }
  }

  @override
  Future<List<CharacterModel>> getFriends(String characterId) async {
    try {
      final response = await manager
          .send<List<CharacterModel>, List<CharacterModel>>(
            _CharacterAPI.getFriends.withId(characterId),
            parseModel: <CharacterModel>[],
            method: RequestType.GET,
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Get friends error - ${response.error}',
        );
        return [];
      }

      return response.data ?? [];
    } catch (e) {
      printDev.exception('CharacterService: Get friends exception - $e');
      return [];
    }
  }

  @override
  Future<List<CharacterModel>> searchCharacters(
    String query, {
    int limit = 20,
  }) async {
    try {
      final response = await manager
          .send<List<CharacterModel>, List<CharacterModel>>(
            _CharacterAPI.searchCharacters.apiPath,
            parseModel: <CharacterModel>[],
            method: RequestType.GET,
            queryParameters: {'query': query, 'limit': limit.toString()},
          );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Search characters error - ${response.error}',
        );
        return [];
      }

      return response.data ?? [];
    } catch (e) {
      printDev.exception('CharacterService: Search characters exception - $e');
      return [];
    }
  }

  @override
  Future<CharacterModel?> getCharacterByUsername(String username) async {
    try {
      final response = await manager.send<CharacterModel, CharacterModel>(
        _CharacterAPI.getCharacterByUsername.withParams({'username': username}),
        parseModel: CharacterModel(),
        method: RequestType.GET,
      );

      if (response.error != null) {
        printDev.exception(
          'CharacterService: Get character by username error - ${response.error}',
        );
        return null;
      }

      return response.data;
    } catch (e) {
      printDev.exception(
        'CharacterService: Get character by username exception - $e',
      );
      return null;
    }
  }
}
