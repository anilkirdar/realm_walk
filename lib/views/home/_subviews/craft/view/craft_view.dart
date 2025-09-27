import 'package:json_annotation/json_annotation.dart';

part 'craft_models.g.dart';

enum CraftCategory { weapons, armor, tools, potions, materials, accessories }

enum ItemRarity { common, uncommon, rare, epic, legendary }

@JsonSerializable()
class CraftMaterial {
  final String itemId;
  final String itemName;
  final int quantity;
  final String? iconPath;

  const CraftMaterial({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    this.iconPath,
  });

  factory CraftMaterial.fromJson(Map<String, dynamic> json) =>
      _$CraftMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$CraftMaterialToJson(this);
}

@JsonSerializable()
class CraftResult {
  final String name;
  final String type;
  final ItemRarity rarity;
  final String? description;
  final Map<String, dynamic> stats;
  final String? iconPath;

  const CraftResult({
    required this.name,
    required this.type,
    required this.rarity,
    this.description,
    this.stats = const {},
    this.iconPath,
  });

  factory CraftResult.fromJson(Map<String, dynamic> json) =>
      _$CraftResultFromJson(json);

  Map<String, dynamic> toJson() => _$CraftResultToJson(this);
}

@JsonSerializable()
class CraftRecipe {
  final String id;
  final CraftCategory category;
  final CraftResult result;
  final List<CraftMaterial> requiredMaterials;
  final int craftTime; // seconds
  final int energyCost;
  final int requiredLevel;
  final double successRate;
  final bool isUnlocked;

  const CraftRecipe({
    required this.id,
    required this.category,
    required this.result,
    required this.requiredMaterials,
    required this.craftTime,
    required this.energyCost,
    this.requiredLevel = 1,
    this.successRate = 1.0,
    this.isUnlocked = false,
  });

  factory CraftRecipe.fromJson(Map<String, dynamic> json) =>
      _$CraftRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$CraftRecipeToJson(this);
}

@JsonSerializable()
class CraftingResult {
  final bool success;
  final CraftedItem? craftedItem;
  final String? errorMessage;
  final int experienceGained;
  final List<String> bonusEffects;

  const CraftingResult({
    required this.success,
    this.craftedItem,
    this.errorMessage,
    this.experienceGained = 0,
    this.bonusEffects = const [],
  });

  factory CraftingResult.fromJson(Map<String, dynamic> json) =>
      _$CraftingResultFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingResultToJson(this);
}

@JsonSerializable()
class CraftedItem {
  final String id;
  final String name;
  final String type;
  final ItemRarity rarity;
  final String? description;
  final Map<String, dynamic> stats;
  final DateTime craftedAt;
  final String craftedBy;
  final double quality; // 0.0 to 1.0

  const CraftedItem({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.description,
    this.stats = const {},
    required this.craftedAt,
    required this.craftedBy,
    this.quality = 1.0,
  });

  factory CraftedItem.fromJson(Map<String, dynamic> json) =>
      _$CraftedItemFromJson(json);

  Map<String, dynamic> toJson() => _$CraftedItemToJson(this);
}

@JsonSerializable()
class InventoryItem {
  final String itemId;
  final String name;
  final String type;
  final ItemRarity rarity;
  final int quantity;
  final Map<String, dynamic> stats;
  final String? iconPath;
  final String? description;
  final bool isEquipped;
  final DateTime obtainedAt;

  const InventoryItem({
    required this.itemId,
    required this.name,
    required this.type,
    required this.rarity,
    required this.quantity,
    this.stats = const {},
    this.iconPath,
    this.description,
    this.isEquipped = false,
    required this.obtainedAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  InventoryItem copyWith({
    String? itemId,
    String? name,
    String? type,
    ItemRarity? rarity,
    int? quantity,
    Map<String, dynamic>? stats,
    String? iconPath,
    String? description,
    bool? isEquipped,
    DateTime? obtainedAt,
  }) {
    return InventoryItem(
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      quantity: quantity ?? this.quantity,
      stats: stats ?? this.stats,
      iconPath: iconPath ?? this.iconPath,
      description: description ?? this.description,
      isEquipped: isEquipped ?? this.isEquipped,
      obtainedAt: obtainedAt ?? this.obtainedAt,
    );
  }
}

@JsonSerializable()
class CraftingQueue {
  final String id;
  final String recipeId;
  final String recipeName;
  final int quantity;
  final DateTime startTime;
  final DateTime completionTime;
  final CraftingStatus status;
  final int energyCost;

  const CraftingQueue({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.quantity,
    required this.startTime,
    required this.completionTime,
    required this.status,
    required this.energyCost,
  });

  factory CraftingQueue.fromJson(Map<String, dynamic> json) =>
      _$CraftingQueueFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingQueueToJson(this);

  // Calculate remaining time
  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(completionTime)) {
      return Duration.zero;
    }
    return completionTime.difference(now);
  }

  // Calculate progress percentage (0.0 to 1.0)
  double get progress {
    final now = DateTime.now();
    final total = completionTime.difference(startTime);
    final elapsed = now.difference(startTime);

    if (elapsed.inMilliseconds <= 0) return 0.0;
    if (elapsed >= total) return 1.0;

    return elapsed.inMilliseconds / total.inMilliseconds;
  }

  // Check if crafting is complete
  bool get isComplete => DateTime.now().isAfter(completionTime);
}

enum CraftingStatus { in_progress, completed, collected, cancelled }

@JsonSerializable()
class CraftingSession {
  final String playerId;
  final List<CraftingQueue> queue;
  final int maxSlots;
  final int usedEnergy;
  final int maxEnergy;
  final DateTime lastUpdated;

  const CraftingSession({
    required this.playerId,
    required this.queue,
    this.maxSlots = 3,
    required this.usedEnergy,
    required this.maxEnergy,
    required this.lastUpdated,
  });

  factory CraftingSession.fromJson(Map<String, dynamic> json) =>
      _$CraftingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingSessionToJson(this);

  // Get active crafting items
  List<CraftingQueue> get activeCrafting =>
      queue.where((item) => item.status == CraftingStatus.in_progress).toList();

  // Get completed crafting items
  List<CraftingQueue> get completedCrafting =>
      queue.where((item) => item.status == CraftingStatus.completed).toList();

  // Check if can start new crafting
  bool get canStartCrafting => activeCrafting.length < maxSlots;

  // Get available energy
  int get availableEnergy => maxEnergy - usedEnergy;

  // Check if has enough energy for cost
  bool hasEnoughEnergy(int cost) => availableEnergy >= cost;
}

@JsonSerializable()
class RecipeUnlockCondition {
  final String type; // 'level', 'item', 'quest', 'skill'
  final String requirement;
  final int value;
  final String description;

  const RecipeUnlockCondition({
    required this.type,
    required this.requirement,
    required this.value,
    required this.description,
  });

  factory RecipeUnlockCondition.fromJson(Map<String, dynamic> json) =>
      _$RecipeUnlockConditionFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeUnlockConditionToJson(this);
}

@JsonSerializable()
class CraftingExperience {
  final String category;
  final int currentExp;
  final int level;
  final int expToNextLevel;
  final double craftSpeedBonus;
  final double successRateBonus;

  const CraftingExperience({
    required this.category,
    required this.currentExp,
    required this.level,
    required this.expToNextLevel,
    this.craftSpeedBonus = 0.0,
    this.successRateBonus = 0.0,
  });

  factory CraftingExperience.fromJson(Map<String, dynamic> json) =>
      _$CraftingExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$CraftingExperienceToJson(this);

  // Calculate progress to next level
  double get progressToNextLevel {
    if (expToNextLevel <= 0) return 1.0;
    return currentExp / (currentExp + expToNextLevel);
  }
}
