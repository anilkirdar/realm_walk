import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/craft_models.dart';
import '../service/craft_service.dart';
import 'i_craft_provider.dart';

class CraftProvider with ChangeNotifier implements ICraftProvider {
  CraftService craftService = CraftService();

  List<CraftRecipe> _availableRecipes = [];
  CraftingSession? _craftingSession;
  bool _isLoading = false;
  String? _error;

  // Active crafting timers
  Map<String, Timer> _craftingTimers = {};

  // Getters
  List<CraftRecipe> get availableRecipes => _availableRecipes;
  CraftingSession? get craftingSession => _craftingSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    await loadRecipes();
    await _loadCraftingSession();
    _startCraftingTimers();
  }

  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availableRecipes = await craftService.getAvailableRecipes();
    } catch (e) {
      _error = 'Failed to load recipes: $e';
      await _loadRecipesFromLocal();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadRecipesFromLocal() async {
    // Default recipes if server is unavailable
    _availableRecipes = [
      CraftRecipe(
        id: 'iron_sword',
        category: CraftCategory.weapons,
        result: CraftResult(
          name: 'Iron Sword',
          type: 'weapon',
          rarity: ItemRarity.common,
          description: 'A sturdy iron sword with good balance',
          stats: {'attack': 25, 'durability': 100},
        ),
        requiredMaterials: [
          CraftMaterial(
            itemId: 'iron_ingot',
            itemName: 'Iron Ingot',
            quantity: 3,
          ),
          CraftMaterial(itemId: 'wood', itemName: 'Wood', quantity: 1),
          CraftMaterial(itemId: 'leather', itemName: 'Leather', quantity: 1),
        ],
        craftTime: 30,
        energyCost: 20,
        requiredLevel: 1,
        isUnlocked: true,
      ),
      CraftRecipe(
        id: 'health_potion',
        category: CraftCategory.potions,
        result: CraftResult(
          name: 'Health Potion',
          type: 'consumable',
          rarity: ItemRarity.common,
          description: 'Restores 50 HP when consumed',
          stats: {'healing': 50},
        ),
        requiredMaterials: [
          CraftMaterial(itemId: 'red_herb', itemName: 'Red Herb', quantity: 2),
          CraftMaterial(itemId: 'water', itemName: 'Pure Water', quantity: 1),
        ],
        craftTime: 15,
        energyCost: 10,
        requiredLevel: 1,
        isUnlocked: true,
      ),
      CraftRecipe(
        id: 'leather_armor',
        category: CraftCategory.armor,
        result: CraftResult(
          name: 'Leather Armor',
          type: 'armor',
          rarity: ItemRarity.common,
          description: 'Basic leather protection for the torso',
          stats: {'defense': 15, 'durability': 80},
        ),
        requiredMaterials: [
          CraftMaterial(itemId: 'leather', itemName: 'Leather', quantity: 5),
          CraftMaterial(itemId: 'thread', itemName: 'Thread', quantity: 3),
          CraftMaterial(
            itemId: 'metal_buckle',
            itemName: 'Metal Buckle',
            quantity: 2,
          ),
        ],
        craftTime: 45,
        energyCost: 25,
        requiredLevel: 2,
        isUnlocked: true,
      ),
      CraftRecipe(
        id: 'steel_pickaxe',
        category: CraftCategory.tools,
        result: CraftResult(
          name: 'Steel Pickaxe',
          type: 'tool',
          rarity: ItemRarity.uncommon,
          description: 'A durable pickaxe for mining rare ores',
          stats: {'mining_power': 35, 'durability': 150},
        ),
        requiredMaterials: [
          CraftMaterial(
            itemId: 'steel_ingot',
            itemName: 'Steel Ingot',
            quantity: 4,
          ),
          CraftMaterial(itemId: 'oak_wood', itemName: 'Oak Wood', quantity: 2),
        ],
        craftTime: 60,
        energyCost: 30,
        requiredLevel: 3,
        isUnlocked: true,
      ),
      CraftRecipe(
        id: 'mana_crystal',
        category: CraftCategory.materials,
        result: CraftResult(
          name: 'Mana Crystal',
          type: 'material',
          rarity: ItemRarity.rare,
          description: 'A crystallized form of magical energy',
          stats: {'mana_value': 100},
        ),
        requiredMaterials: [
          CraftMaterial(
            itemId: 'raw_crystal',
            itemName: 'Raw Crystal',
            quantity: 3,
          ),
          CraftMaterial(
            itemId: 'mana_essence',
            itemName: 'Mana Essence',
            quantity: 5,
          ),
          CraftMaterial(
            itemId: 'catalyst_powder',
            itemName: 'Catalyst Powder',
            quantity: 1,
          ),
        ],
        craftTime: 120,
        energyCost: 50,
        requiredLevel: 5,
        isUnlocked: true,
      ),
    ];
  }

  Future<void> _loadCraftingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString('crafting_session');

      if (sessionJson != null) {
        final sessionData = jsonDecode(sessionJson);
        _craftingSession = CraftingSession.fromJson(sessionData);
      } else {
        // Initialize with default crafting session
        _craftingSession = CraftingSession(
          playerId: 'player_1', // This would come from auth
          queue: [],
          maxSlots: 3,
          usedEnergy: 0,
          maxEnergy: 100,
          lastUpdated: DateTime.now(),
        );
      }
    } catch (e) {
      // Create default session if loading fails
      _craftingSession = CraftingSession(
        playerId: 'player_1',
        queue: [],
        maxSlots: 3,
        usedEnergy: 0,
        maxEnergy: 100,
        lastUpdated: DateTime.now(),
      );
    }
  }

  Future<void> _saveCraftingSession() async {
    if (_craftingSession == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = jsonEncode(_craftingSession!.toJson());
      await prefs.setString('crafting_session', sessionJson);
    } catch (e) {
      print('Failed to save crafting session: $e');
    }
  }

  List<CraftRecipe> getRecipesByCategory(CraftCategory category) {
    return _availableRecipes
        .where((recipe) => recipe.category == category)
        .toList();
  }

  bool canCraftRecipe(CraftRecipe recipe, List<InventoryItem> inventory) {
    if (_craftingSession == null) return false;

    // Check energy
    if (!_craftingSession!.hasEnoughEnergy(recipe.energyCost)) {
      return false;
    }

    // Check crafting slots
    if (!_craftingSession!.canStartCrafting) {
      return false;
    }

    // Check materials
    for (final material in recipe.requiredMaterials) {
      final availableQuantity = inventory
          .where((item) => item.itemId == material.itemId)
          .fold(0, (sum, item) => sum + item.quantity);

      if (availableQuantity < material.quantity) {
        return false;
      }
    }

    return true;
  }

  bool isCrafting(String recipeId) {
    if (_craftingSession == null) return false;

    return _craftingSession!.activeCrafting.any(
      (item) => item.recipeId == recipeId,
    );
  }

  Future<CraftingResult> craftItem(CraftRecipe recipe) async {
    if (_craftingSession == null) {
      return CraftingResult(
        success: false,
        errorMessage: 'No crafting session available',
      );
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Create crafting queue item
      final craftingItem = CraftingQueue(
        id: 'craft_${DateTime.now().millisecondsSinceEpoch}',
        recipeId: recipe.id,
        recipeName: recipe.result.name,
        quantity: 1,
        startTime: DateTime.now(),
        completionTime: DateTime.now().add(Duration(seconds: recipe.craftTime)),
        status: CraftingStatus.in_progress,
        energyCost: recipe.energyCost,
      );

      // Add to queue
      final updatedQueue = List<CraftingQueue>.from(_craftingSession!.queue);
      updatedQueue.add(craftingItem);

      // Update session
      _craftingSession = CraftingSession(
        playerId: _craftingSession!.playerId,
        queue: updatedQueue,
        maxSlots: _craftingSession!.maxSlots,
        usedEnergy: _craftingSession!.usedEnergy + recipe.energyCost,
        maxEnergy: _craftingSession!.maxEnergy,
        lastUpdated: DateTime.now(),
      );

      await _saveCraftingSession();

      // Start timer for this crafting
      _startCraftingTimer(craftingItem);

      _isLoading = false;
      notifyListeners();

      return CraftingResult(
        success: true,
        experienceGained: recipe.craftTime ~/ 2, // Simple XP calculation
      );
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to start crafting: $e';
      notifyListeners();

      return CraftingResult(success: false, errorMessage: e.toString());
    }
  }

  void _startCraftingTimers() {
    if (_craftingSession == null) return;

    for (final item in _craftingSession!.activeCrafting) {
      _startCraftingTimer(item);
    }
  }

  void _startCraftingTimer(CraftingQueue item) {
    final remaining = item.remainingTime;

    if (remaining.inMilliseconds <= 0) {
      // Already completed
      _completeCrafting(item.id);
      return;
    }

    _craftingTimers[item.id] = Timer(remaining, () {
      _completeCrafting(item.id);
    });
  }

  void _completeCrafting(String craftingId) {
    if (_craftingSession == null) return;

    // Find and update the item status
    final updatedQueue = _craftingSession!.queue.map((item) {
      if (item.id == craftingId) {
        return CraftingQueue(
          id: item.id,
          recipeId: item.recipeId,
          recipeName: item.recipeName,
          quantity: item.quantity,
          startTime: item.startTime,
          completionTime: item.completionTime,
          status: CraftingStatus.completed,
          energyCost: item.energyCost,
        );
      }
      return item;
    }).toList();

    _craftingSession = CraftingSession(
      playerId: _craftingSession!.playerId,
      queue: updatedQueue,
      maxSlots: _craftingSession!.maxSlots,
      usedEnergy: _craftingSession!.usedEnergy,
      maxEnergy: _craftingSession!.maxEnergy,
      lastUpdated: DateTime.now(),
    );

    _craftingTimers.remove(craftingId);
    _saveCraftingSession();
    notifyListeners();
  }

  Future<List<CraftedItem>> collectCompletedItems() async {
    if (_craftingSession == null) return [];

    final completedItems = _craftingSession!.completedCrafting;
    if (completedItems.isEmpty) return [];

    List<CraftedItem> collectedItems = [];

    try {
      for (final item in completedItems) {
        final recipe = _availableRecipes.firstWhere(
          (r) => r.id == item.recipeId,
          orElse: () => throw Exception('Recipe not found'),
        );

        // Create crafted item
        final craftedItem = CraftedItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}_${item.id}',
          name: recipe.result.name,
          type: recipe.result.type,
          rarity: recipe.result.rarity,
          description: recipe.result.description,
          stats: recipe.result.stats,
          craftedAt: DateTime.now(),
          craftedBy: _craftingSession!.playerId,
          quality:
              0.8 + (DateTime.now().millisecond % 20) / 100, // Random quality
        );

        collectedItems.add(craftedItem);
      }

      // Remove collected items from queue and restore energy
      final updatedQueue = _craftingSession!.queue
          .where((item) => item.status != CraftingStatus.completed)
          .toList();

      final restoredEnergy = completedItems.fold(
        0,
        (sum, item) => sum + item.energyCost,
      );

      _craftingSession = CraftingSession(
        playerId: _craftingSession!.playerId,
        queue: updatedQueue,
        maxSlots: _craftingSession!.maxSlots,
        usedEnergy: (_craftingSession!.usedEnergy - restoredEnergy).clamp(
          0,
          _craftingSession!.maxEnergy,
        ),
        maxEnergy: _craftingSession!.maxEnergy,
        lastUpdated: DateTime.now(),
      );

      await _saveCraftingSession();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to collect items: $e';
      notifyListeners();
    }

    return collectedItems;
  }

  Future<bool> cancelCrafting(String craftingId) async {
    if (_craftingSession == null) return false;

    try {
      // Find the item to cancel
      final itemToCancel = _craftingSession!.queue.firstWhere(
        (item) =>
            item.id == craftingId && item.status == CraftingStatus.in_progress,
        orElse: () =>
            throw Exception('Crafting item not found or not in progress'),
      );

      // Calculate refund (50% of energy back)
      final energyRefund = (itemToCancel.energyCost * 0.5).round();

      // Remove from queue
      final updatedQueue = _craftingSession!.queue
          .where((item) => item.id != craftingId)
          .toList();

      _craftingSession = CraftingSession(
        playerId: _craftingSession!.playerId,
        queue: updatedQueue,
        maxSlots: _craftingSession!.maxSlots,
        usedEnergy: (_craftingSession!.usedEnergy - energyRefund).clamp(
          0,
          _craftingSession!.maxEnergy,
        ),
        maxEnergy: _craftingSession!.maxEnergy,
        lastUpdated: DateTime.now(),
      );

      // Cancel timer
      _craftingTimers[craftingId]?.cancel();
      _craftingTimers.remove(craftingId);

      await _saveCraftingSession();
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to cancel crafting: $e';
      notifyListeners();
      return false;
    }
  }

  Duration getCraftingTimeRemaining(String craftingId) {
    final item = _craftingSession?.queue.firstWhere(
      (item) => item.id == craftingId,
      orElse: () => CraftingQueue(
        id: '',
        recipeId: '',
        recipeName: '',
        quantity: 0,
        startTime: DateTime.now(),
        completionTime: DateTime.now(),
        status: CraftingStatus.completed,
        energyCost: 0,
      ),
    );

    return item?.remainingTime ?? Duration.zero;
  }

  double getCraftingProgress(String craftingId) {
    final item = _craftingSession?.queue.firstWhere(
      (item) => item.id == craftingId,
      orElse: () => CraftingQueue(
        id: '',
        recipeId: '',
        recipeName: '',
        quantity: 0,
        startTime: DateTime.now(),
        completionTime: DateTime.now(),
        status: CraftingStatus.completed,
        energyCost: 0,
      ),
    );

    return item?.progress ?? 1.0;
  }

  List<CraftingQueue> getActiveCrafting() {
    return _craftingSession?.activeCrafting ?? [];
  }

  List<CraftingQueue> getCompletedCrafting() {
    return _craftingSession?.completedCrafting ?? [];
  }

  bool hasAvailableCraftingSlot() {
    return _craftingSession?.canStartCrafting ?? false;
  }

  int getAvailableEnergy() {
    return _craftingSession?.availableEnergy ?? 0;
  }

  Future<void> restoreEnergy(int amount) async {
    if (_craftingSession == null) return;

    _craftingSession = CraftingSession(
      playerId: _craftingSession!.playerId,
      queue: _craftingSession!.queue,
      maxSlots: _craftingSession!.maxSlots,
      usedEnergy: (_craftingSession!.usedEnergy - amount).clamp(
        0,
        _craftingSession!.maxEnergy,
      ),
      maxEnergy: _craftingSession!.maxEnergy,
      lastUpdated: DateTime.now(),
    );

    await _saveCraftingSession();
    notifyListeners();
  }

  Future<void> upgradeWorkshop() async {
    if (_craftingSession == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Increase max slots (this would typically cost resources)
      _craftingSession = CraftingSession(
        playerId: _craftingSession!.playerId,
        queue: _craftingSession!.queue,
        maxSlots: _craftingSession!.maxSlots + 1,
        usedEnergy: _craftingSession!.usedEnergy,
        maxEnergy: _craftingSession!.maxEnergy + 20, // Increase max energy too
        lastUpdated: DateTime.now(),
      );

      await _saveCraftingSession();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to upgrade workshop: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CraftRecipe> getRecommendedRecipes(List<InventoryItem> inventory) {
    // Find recipes that player has most materials for
    return _availableRecipes.where((recipe) {
      int materialCount = 0;
      for (final material in recipe.requiredMaterials) {
        final hasItem = inventory.any(
          (item) =>
              item.itemId == material.itemId &&
              item.quantity >= material.quantity,
        );
        if (hasItem) materialCount++;
      }
      // Return recipes where player has at least half the materials
      return materialCount >= (recipe.requiredMaterials.length / 2).ceil();
    }).toList()..sort(
      (a, b) =>
          b.requiredMaterials.length.compareTo(a.requiredMaterials.length),
    );
  }

  CraftRecipe? getRecipeById(String recipeId) {
    try {
      return _availableRecipes.firstWhere((recipe) => recipe.id == recipeId);
    } catch (e) {
      return null;
    }
  }

  Map<CraftCategory, int> getRecipeCountByCategory() {
    final counts = <CraftCategory, int>{};
    for (final category in CraftCategory.values) {
      counts[category] = _availableRecipes
          .where((r) => r.category == category)
          .length;
    }
    return counts;
  }

  Future<void> unlockRecipe(String recipeId) async {
    // This would typically involve checking unlock conditions
    final recipeIndex = _availableRecipes.indexWhere((r) => r.id == recipeId);
    if (recipeIndex != -1) {
      // In a real implementation, you'd update the recipe on the server
      // For now, just mark as unlocked locally
      print('Recipe $recipeId unlocked!');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadRecipes();
    await _loadCraftingSession();
  }

  @override
  void dispose() {
    // Cancel all active timers
    for (final timer in _craftingTimers.values) {
      timer.cancel();
    }
    _craftingTimers.clear();

    _saveCraftingSession();
    super.dispose();
  }
}
