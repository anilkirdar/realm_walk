import 'package:vexana/vexana.dart';

import '../../../../core/init/firebase/crashlytics/crashlytics_manager.dart';
import '../../../../core/init/network/model/error_model_custom.dart';
import '../model/character_model.dart';
import '../model/character_stats_model.dart';
import '../model/character_update_response.dart';
import '../model/nearby_character_model.dart';

abstract class ICharacterService {
  ICharacterService(this.manager);

  final INetworkManager<ErrorModelCustom> manager;
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  final CrashlyticsMessages crashlyticsMessages = CrashlyticsMessages.instance;

  // Character management
  Future<CharacterModel?> getCharacterInfo(String characterId);
  Future<CharacterModel?> createCharacter(CharacterModel character);
  Future<CharacterModel?> updateCharacter(
    String characterId,
    Map<String, dynamic> updates,
  );
  Future<bool> deleteCharacter(String characterId);

  // Character stats
  Future<CharacterStatsModel?> getCharacterStats(String characterId);
  Future<CharacterStatsModel?> updateCharacterStats(
    String characterId,
    CharacterStatsModel stats,
  );

  // Location updates
  Future<CharacterUpdateResponse?> updateLocation(
    double latitude,
    double longitude,
  );
  Future<List<NearbyCharacter>> getNearbyCharacters(
    double latitude,
    double longitude, {
    int radius = 500,
  });

  // Character progression
  Future<bool> gainExperience(String characterId, int experience);
  Future<bool> levelUp(String characterId);
  Future<bool> updateSkill(String characterId, String skillId, int newLevel);

  // Character appearance
  Future<bool> updateAppearance(
    String characterId,
    Map<String, dynamic> appearance,
  );
  Future<bool> updateEquipment(
    String characterId,
    Map<String, dynamic> equipment,
  );

  // Character status
  Future<bool> setOnlineStatus(String characterId, bool isOnline);
  Future<bool> setActivityStatus(String characterId, String activity);

  // Social features
  Future<bool> sendFriendRequest(String fromCharacterId, String toCharacterId);
  Future<bool> acceptFriendRequest(String requestId);
  Future<bool> rejectFriendRequest(String requestId);
  Future<List<CharacterModel>> getFriends(String characterId);

  // Character search
  Future<List<CharacterModel>> searchCharacters(String query, {int limit = 20});
  Future<CharacterModel?> getCharacterByUsername(String username);
}
