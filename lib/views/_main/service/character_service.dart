import 'package:vexana/vexana.dart';

import '../../../../core/constants/network/api_const.dart';
import '../../../../core/init/cache/local_manager.dart';
import '../../../../product/enum/local_keys_enum.dart';
import '../model/character_model.dart';
import '../model/character_response_model.dart';
import '../model/nearby_character_model.dart';
import '../model/nearby_character_response_model.dart';
import 'i_character_service.dart';

class CharacterService extends ICharacterService {
  CharacterService(super.manager);

  LocalManager localManager = LocalManager.instance;

  // Update character location
  @override
  Future<bool> updateLocation(double latitude, double longitude) async {
    try {
      final token = localManager.getStringValue(LocalManagerKeys.token);
      if (token == '') return false;

      final response = await manager.send<EmptyModel, EmptyModel>(
        APIConst.updateCharacterLocation,
        parseModel: EmptyModel(),
        method: RequestType.PUT,
        data: {'latitude': latitude, 'longitude': longitude},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.error != null) {
        print('Error updating location: ${response.error}');
        return false;
      }
      return true;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }

  // Get nearby characters
  @override
  Future<List<NearbyCharacter>> getNearbyCharacters({int radius = 1000}) async {
    try {
      final token = localManager.getStringValue(LocalManagerKeys.token);
      if (token == '') return [];

      final response = await manager
          .send<NearbyCharacterResponseModel, NearbyCharacterResponseModel>(
            APIConst.getNearbyCharacters(radius),
            parseModel: NearbyCharacterResponseModel(),
            method: RequestType.GET,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.error != null) {
        print('Error getting nearby characters: ${response.error}');
        return [];
      }

      return response.data?.nearbyCharacters ?? [];
    } catch (e) {
      print('Error getting nearby characters: $e');
      return [];
    }
  }

  // Update character stats
  @override
  Future<CharacterModel?> updateStats({
    int? experience,
    int? health,
    int? mana,
  }) async {
    try {
      final token = localManager.getStringValue(LocalManagerKeys.token);
      if (token == '') return null;

      final Map<String, dynamic> updateData = {};
      if (experience != null) updateData['experience'] = experience;
      if (health != null) updateData['health'] = health;
      if (mana != null) updateData['mana'] = mana;

      final response = await manager
          .send<CharacterResponseModel, CharacterResponseModel>(
            APIConst.updateCharacterStats,
            parseModel: CharacterResponseModel(),
            method: RequestType.PUT,
            data: updateData,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.error != null) {
        print('Error updating stats: ${response.error}');
        return null;
      }

      return response.data?.character;
    } catch (e) {
      print('Error updating stats: $e');
      return null;
    }
  }

  // Add item to inventory
  @override
  Future<bool> addItemToInventory(String itemId, {int quantity = 1}) async {
    try {
      final token = localManager.getStringValue(LocalManagerKeys.token);
      if (token == '') return false;

      final response = await manager.send<EmptyModel, EmptyModel>(
        APIConst.addItemToInventory,
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {'itemId': itemId, 'quantity': quantity},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.error != null) {
        print('Error adding item to inventory: ${response.error}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error adding item to inventory: $e');
      return false;
    }
  }

  // Get character profile
  @override
  Future<CharacterModel?> getCharacterProfile() async {
    try {
      final token = localManager.getStringValue(LocalManagerKeys.token);
      if (token == '') return null;

      final response = await manager
          .send<CharacterResponseModel, CharacterResponseModel>(
            APIConst.getCharacterProfile,
            parseModel: CharacterResponseModel(),
            method: RequestType.GET,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.error != null) {
        print('Error getting character profile: ${response.error}');
        return null;
      }

      return response.data?.character;
    } catch (e) {
      print('Error getting character profile: $e');
      return null;
    }
  }
}
