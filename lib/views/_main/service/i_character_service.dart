import 'package:vexana/vexana.dart';

import '../../../../core/init/network/model/error_model_custom.dart';
import '../model/character_model.dart';
import '../model/nearby_character_model.dart';

abstract class ICharacterService {
  ICharacterService(this.manager);

  final INetworkManager<ErrorModelCustom> manager;

  Future<bool> updateLocation(double latitude, double longitude);

  Future<List<NearbyCharacter>> getNearbyCharacters({int radius = 1000});

  Future<CharacterModel?> updateStats({
    int? experience,
    int? health,
    int? mana,
  });

  Future<bool> addItemToInventory(String itemId, {int quantity = 1});

  Future<CharacterModel?> getCharacterProfile();
}
