import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'craft_models.g.dart';

// Crafting Material Model
@JsonSerializable()
class CraftingMaterial extends INetworkModel<CraftingMaterial> {
  final String? id;
  final String? name;
  final String? description;
  final String? category;
  final String? rarity;
  final String? iconUrl;
  final int? maxStack;
  final double? weight;
  final Map<String, dynamic>? properties;
  final List<String>? usageTypes; // ['crafting', 'alchemy', 'enchanting']
  final double? marketValue;
  final bool? isConsumable;
  final DateTime? expiresAt;

  const CraftingMaterial({
    this.id,
    this.name,
    this.description,
    this.category,
    this.rarity,
    this.iconUrl,
    this.maxStack,
    this.weight,
    this.properties,
    this.usageTypes,
    this.marketValue,
    this.isConsumable,
    this.expiresAt,
  });

  factory CraftingMaterial.fromJson(Map<String, dynamic> json) =>
      _$CraftingMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingMaterialToJson(this);

  @override
  CraftingMaterial fromJson(Map<String, dynamic> json) =>
      _$CraftingMaterialFromJson(json);
}

// Crafting Recipe Model
@JsonSerializable()
class CraftingRecipe extends INetworkModel<CraftingRecipe> {
  final String? id;
  final String? name;
  final String? description;
  final String? category;
  final String? craftingType; // ['weapon', 'armor', 'consumable', 'tool']
  final List<CraftingIngredient>? ingredients;
  final CraftingResult? result;
  final int? requiredLevel;
  final String? requiredSkill;
  final int? craftingTime; // in seconds
  final double? successRate;
  final int? experienceReward;
  final List<String>? requiredTools;
  final String?
  craftingStation; // ['anvil', 'alchemy_table', 'enchanting_table']
  final bool? isLearned;
  final DateTime? unlockedAt;

  const CraftingRecipe({
    this.id,
    this.name,
    this.description,
    this.category,
    this.craftingType,
    this.ingredients,
    this.result,
    this.requiredLevel,
    this.requiredSkill,
    this.craftingTime,
    this.successRate,
    this.experienceReward,
    this.requiredTools,
    this.craftingStation,
    this.isLearned,
    this.unlockedAt,
  });

  factory CraftingRecipe.fromJson(Map<String, dynamic> json) =>
      _$CraftingRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingRecipeToJson(this);

  @override
  CraftingRecipe fromJson(Map<String, dynamic> json) =>
      _$CraftingRecipeFromJson(json);
}

// Crafting Ingredient Model
@JsonSerializable()
class CraftingIngredient extends INetworkModel<CraftingIngredient> {
  final String? materialId;
  final String? materialName;
  final int? quantity;
  final String? quality; // ['poor', 'common', 'rare', 'epic', 'legendary']
  final bool? isOptional;
  final List<String>? alternatives; // alternative material IDs

  const CraftingIngredient({
    this.materialId,
    this.materialName,
    this.quantity,
    this.quality,
    this.isOptional,
    this.alternatives,
  });

  factory CraftingIngredient.fromJson(Map<String, dynamic> json) =>
      _$CraftingIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingIngredientToJson(this);

  @override
  CraftingIngredient fromJson(Map<String, dynamic> json) =>
      _$CraftingIngredientFromJson(json);
}

// Crafting Result Model
@JsonSerializable()
class CraftingResult extends INetworkModel<CraftingResult> {
  final String? itemId;
  final String? itemName;
  final int? quantity;
  final String? quality;
  final Map<String, dynamic>? attributes;
  final List<String>? enchantments;
  final double? durability;
  final int? sellValue;

  const CraftingResult({
    this.itemId,
    this.itemName,
    this.quantity,
    this.quality,
    this.attributes,
    this.enchantments,
    this.durability,
    this.sellValue,
  });

  factory CraftingResult.fromJson(Map<String, dynamic> json) =>
      _$CraftingResultFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingResultToJson(this);

  @override
  CraftingResult fromJson(Map<String, dynamic> json) =>
      _$CraftingResultFromJson(json);
}

// Crafting Session Model
@JsonSerializable()
class CraftingSession extends INetworkModel<CraftingSession> {
  final String? id;
  final String? recipeId;
  final String? playerId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? remainingTime;
  final String? status; // ['in_progress', 'completed', 'failed', 'cancelled']
  final double? progress; // 0.0 to 1.0
  final bool? isAutomatic;
  final Map<String, dynamic>? sessionData;

  const CraftingSession({
    this.id,
    this.recipeId,
    this.playerId,
    this.startedAt,
    this.completedAt,
    this.remainingTime,
    this.status,
    this.progress,
    this.isAutomatic,
    this.sessionData,
  });

  factory CraftingSession.fromJson(Map<String, dynamic> json) =>
      _$CraftingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingSessionToJson(this);

  @override
  CraftingSession fromJson(Map<String, dynamic> json) =>
      _$CraftingSessionFromJson(json);
}

// Equipment Item Model
@JsonSerializable()
class EquipmentItem extends INetworkModel<EquipmentItem> {
  final String? id;
  final String? name;
  final String? description;
  final String? type; // ['weapon', 'armor', 'accessory', 'tool']
  final String? subType; // ['sword', 'bow', 'helmet', 'chestplate', 'ring']
  final String? rarity;
  final int? level;
  final Map<String, dynamic>? stats; // {'attack': 25, 'defense': 15}
  final List<String>? enchantments;
  final double? durability;
  final double? maxDurability;
  final String? iconUrl;
  final String? modelUrl;
  final int? sellValue;
  final bool? isEquipped;
  final String? equippedSlot;
  final DateTime? acquiredAt;
  final String? craftedBy;

  const EquipmentItem({
    this.id,
    this.name,
    this.description,
    this.type,
    this.subType,
    this.rarity,
    this.level,
    this.stats,
    this.enchantments,
    this.durability,
    this.maxDurability,
    this.iconUrl,
    this.modelUrl,
    this.sellValue,
    this.isEquipped,
    this.equippedSlot,
    this.acquiredAt,
    this.craftedBy,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) =>
      _$EquipmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentItemToJson(this);

  @override
  EquipmentItem fromJson(Map<String, dynamic> json) =>
      _$EquipmentItemFromJson(json);
}

// Inventory Item Model
@JsonSerializable()
class InventoryItem extends INetworkModel<InventoryItem> {
  final String? id;
  final String? itemId;
  final String? itemType; // ['material', 'equipment', 'consumable', 'quest']
  final String? name;
  final int? quantity;
  final String? quality;
  final Map<String, dynamic>? metadata;
  final DateTime? acquiredAt;
  final DateTime? expiresAt;
  final bool? isStackable;
  final int? slotPosition;

  const InventoryItem({
    this.id,
    this.itemId,
    this.itemType,
    this.name,
    this.quantity,
    this.quality,
    this.metadata,
    this.acquiredAt,
    this.expiresAt,
    this.isStackable,
    this.slotPosition,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  @override
  InventoryItem fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}

// Crafting Skill Model
@JsonSerializable()
class CraftingSkill extends INetworkModel<CraftingSkill> {
  final String? skillId;
  final String? name;
  final String? description;
  final int? level;
  final int? experience;
  final int? maxExperience;
  final List<String>? unlockedRecipes;
  final Map<String, dynamic>?
  bonuses; // {'crafting_speed': 1.2, 'success_rate': 0.05}
  final DateTime? lastUsed;

  const CraftingSkill({
    this.skillId,
    this.name,
    this.description,
    this.level,
    this.experience,
    this.maxExperience,
    this.unlockedRecipes,
    this.bonuses,
    this.lastUsed,
  });

  factory CraftingSkill.fromJson(Map<String, dynamic> json) =>
      _$CraftingSkillFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingSkillToJson(this);

  @override
  CraftingSkill fromJson(Map<String, dynamic> json) =>
      _$CraftingSkillFromJson(json);
}

// Player Inventory Response Model
@JsonSerializable()
class PlayerInventoryResponse extends INetworkModel<PlayerInventoryResponse> {
  final List<InventoryItem>? items;
  final List<EquipmentItem>? equipment;
  final int? totalSlots;
  final int? usedSlots;
  final double? totalWeight;
  final double? maxWeight;
  final DateTime? lastUpdated;

  const PlayerInventoryResponse({
    this.items,
    this.equipment,
    this.totalSlots,
    this.usedSlots,
    this.totalWeight,
    this.maxWeight,
    this.lastUpdated,
  });

  factory PlayerInventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerInventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInventoryResponseToJson(this);

  @override
  PlayerInventoryResponse fromJson(Map<String, dynamic> json) =>
      _$PlayerInventoryResponseFromJson(json);
}

// Crafting Station Model
@JsonSerializable()
class CraftingStation extends INetworkModel<CraftingStation> {
  final String? id;
  final String? name;
  final String? type;
  final String? description;
  final List<String>? supportedRecipeTypes;
  final Map<String, dynamic>? bonuses;
  final bool? isAvailable;
  final double? distance; // distance from player
  final String? location;
  final List<CraftingSession>? activeSessions;

  const CraftingStation({
    this.id,
    this.name,
    this.type,
    this.description,
    this.supportedRecipeTypes,
    this.bonuses,
    this.isAvailable,
    this.distance,
    this.location,
    this.activeSessions,
  });

  factory CraftingStation.fromJson(Map<String, dynamic> json) =>
      _$CraftingStationFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingStationToJson(this);

  @override
  CraftingStation fromJson(Map<String, dynamic> json) =>
      _$CraftingStationFromJson(json);
}
