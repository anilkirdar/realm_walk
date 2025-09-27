// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'craft_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CraftingMaterial _$CraftingMaterialFromJson(Map<String, dynamic> json) =>
    CraftingMaterial(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      rarity: json['rarity'] as String?,
      iconUrl: json['iconUrl'] as String?,
      maxStack: (json['maxStack'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      properties: json['properties'] as Map<String, dynamic>?,
      usageTypes: (json['usageTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      marketValue: (json['marketValue'] as num?)?.toDouble(),
      isConsumable: json['isConsumable'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CraftingMaterialToJson(CraftingMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'rarity': instance.rarity,
      'iconUrl': instance.iconUrl,
      'maxStack': instance.maxStack,
      'weight': instance.weight,
      'properties': instance.properties,
      'usageTypes': instance.usageTypes,
      'marketValue': instance.marketValue,
      'isConsumable': instance.isConsumable,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

CraftingRecipe _$CraftingRecipeFromJson(Map<String, dynamic> json) =>
    CraftingRecipe(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      craftingType: json['craftingType'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => CraftingIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      result: json['result'] == null
          ? null
          : CraftingResult.fromJson(json['result'] as Map<String, dynamic>),
      requiredLevel: (json['requiredLevel'] as num?)?.toInt(),
      requiredSkill: json['requiredSkill'] as String?,
      craftingTime: (json['craftingTime'] as num?)?.toInt(),
      successRate: (json['successRate'] as num?)?.toDouble(),
      experienceReward: (json['experienceReward'] as num?)?.toInt(),
      requiredTools: (json['requiredTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      craftingStation: json['craftingStation'] as String?,
      isLearned: json['isLearned'] as bool?,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$CraftingRecipeToJson(CraftingRecipe instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'craftingType': instance.craftingType,
      'ingredients': instance.ingredients,
      'result': instance.result,
      'requiredLevel': instance.requiredLevel,
      'requiredSkill': instance.requiredSkill,
      'craftingTime': instance.craftingTime,
      'successRate': instance.successRate,
      'experienceReward': instance.experienceReward,
      'requiredTools': instance.requiredTools,
      'craftingStation': instance.craftingStation,
      'isLearned': instance.isLearned,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };

CraftingIngredient _$CraftingIngredientFromJson(Map<String, dynamic> json) =>
    CraftingIngredient(
      materialId: json['materialId'] as String?,
      materialName: json['materialName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      quality: json['quality'] as String?,
      isOptional: json['isOptional'] as bool?,
      alternatives: (json['alternatives'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CraftingIngredientToJson(CraftingIngredient instance) =>
    <String, dynamic>{
      'materialId': instance.materialId,
      'materialName': instance.materialName,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'isOptional': instance.isOptional,
      'alternatives': instance.alternatives,
    };

CraftingResult _$CraftingResultFromJson(Map<String, dynamic> json) =>
    CraftingResult(
      itemId: json['itemId'] as String?,
      itemName: json['itemName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      quality: json['quality'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      enchantments: (json['enchantments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durability: (json['durability'] as num?)?.toDouble(),
      sellValue: (json['sellValue'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CraftingResultToJson(CraftingResult instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'attributes': instance.attributes,
      'enchantments': instance.enchantments,
      'durability': instance.durability,
      'sellValue': instance.sellValue,
    };

CraftingSession _$CraftingSessionFromJson(Map<String, dynamic> json) =>
    CraftingSession(
      id: json['id'] as String?,
      recipeId: json['recipeId'] as String?,
      playerId: json['playerId'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      remainingTime: (json['remainingTime'] as num?)?.toInt(),
      status: json['status'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      isAutomatic: json['isAutomatic'] as bool?,
      sessionData: json['sessionData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CraftingSessionToJson(CraftingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipeId': instance.recipeId,
      'playerId': instance.playerId,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'remainingTime': instance.remainingTime,
      'status': instance.status,
      'progress': instance.progress,
      'isAutomatic': instance.isAutomatic,
      'sessionData': instance.sessionData,
    };

EquipmentItem _$EquipmentItemFromJson(Map<String, dynamic> json) =>
    EquipmentItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      subType: json['subType'] as String?,
      rarity: json['rarity'] as String?,
      level: (json['level'] as num?)?.toInt(),
      stats: json['stats'] as Map<String, dynamic>?,
      enchantments: (json['enchantments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durability: (json['durability'] as num?)?.toDouble(),
      maxDurability: (json['maxDurability'] as num?)?.toDouble(),
      iconUrl: json['iconUrl'] as String?,
      modelUrl: json['modelUrl'] as String?,
      sellValue: (json['sellValue'] as num?)?.toInt(),
      isEquipped: json['isEquipped'] as bool?,
      equippedSlot: json['equippedSlot'] as String?,
      acquiredAt: json['acquiredAt'] == null
          ? null
          : DateTime.parse(json['acquiredAt'] as String),
      craftedBy: json['craftedBy'] as String?,
    );

Map<String, dynamic> _$EquipmentItemToJson(EquipmentItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'subType': instance.subType,
      'rarity': instance.rarity,
      'level': instance.level,
      'stats': instance.stats,
      'enchantments': instance.enchantments,
      'durability': instance.durability,
      'maxDurability': instance.maxDurability,
      'iconUrl': instance.iconUrl,
      'modelUrl': instance.modelUrl,
      'sellValue': instance.sellValue,
      'isEquipped': instance.isEquipped,
      'equippedSlot': instance.equippedSlot,
      'acquiredAt': instance.acquiredAt?.toIso8601String(),
      'craftedBy': instance.craftedBy,
    };

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      id: json['id'] as String?,
      itemId: json['itemId'] as String?,
      itemType: json['itemType'] as String?,
      name: json['name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      quality: json['quality'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      acquiredAt: json['acquiredAt'] == null
          ? null
          : DateTime.parse(json['acquiredAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isStackable: json['isStackable'] as bool?,
      slotPosition: (json['slotPosition'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'name': instance.name,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'metadata': instance.metadata,
      'acquiredAt': instance.acquiredAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isStackable': instance.isStackable,
      'slotPosition': instance.slotPosition,
    };

CraftingSkill _$CraftingSkillFromJson(Map<String, dynamic> json) =>
    CraftingSkill(
      skillId: json['skillId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      level: (json['level'] as num?)?.toInt(),
      experience: (json['experience'] as num?)?.toInt(),
      maxExperience: (json['maxExperience'] as num?)?.toInt(),
      unlockedRecipes: (json['unlockedRecipes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bonuses: json['bonuses'] as Map<String, dynamic>?,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$CraftingSkillToJson(CraftingSkill instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'name': instance.name,
      'description': instance.description,
      'level': instance.level,
      'experience': instance.experience,
      'maxExperience': instance.maxExperience,
      'unlockedRecipes': instance.unlockedRecipes,
      'bonuses': instance.bonuses,
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };

PlayerInventoryResponse _$PlayerInventoryResponseFromJson(
  Map<String, dynamic> json,
) => PlayerInventoryResponse(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  equipment: (json['equipment'] as List<dynamic>?)
      ?.map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalSlots: (json['totalSlots'] as num?)?.toInt(),
  usedSlots: (json['usedSlots'] as num?)?.toInt(),
  totalWeight: (json['totalWeight'] as num?)?.toDouble(),
  maxWeight: (json['maxWeight'] as num?)?.toDouble(),
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$PlayerInventoryResponseToJson(
  PlayerInventoryResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'equipment': instance.equipment,
  'totalSlots': instance.totalSlots,
  'usedSlots': instance.usedSlots,
  'totalWeight': instance.totalWeight,
  'maxWeight': instance.maxWeight,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};

CraftingStation _$CraftingStationFromJson(Map<String, dynamic> json) =>
    CraftingStation(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      supportedRecipeTypes: (json['supportedRecipeTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bonuses: json['bonuses'] as Map<String, dynamic>?,
      isAvailable: json['isAvailable'] as bool?,
      distance: (json['distance'] as num?)?.toDouble(),
      location: json['location'] as String?,
      activeSessions: (json['activeSessions'] as List<dynamic>?)
          ?.map((e) => CraftingSession.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CraftingStationToJson(CraftingStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'supportedRecipeTypes': instance.supportedRecipeTypes,
      'bonuses': instance.bonuses,
      'isAvailable': instance.isAvailable,
      'distance': instance.distance,
      'location': instance.location,
      'activeSessions': instance.activeSessions,
    };
