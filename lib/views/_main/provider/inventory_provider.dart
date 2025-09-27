import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/craft_models.dart';
import '../service/inventory_service.dart';

class InventoryProvider with ChangeNotifier {
  InventoryService inventoryService = InventoryService();

  List<InventoryItem> _items = [];
  Map<String, InventoryItem> _equipment = {};
  bool _isLoading = false;
  String? _error;
  int _maxSlots = 100;

  // Currency
  int _gold = 0;
  int _gems = 0;
  int _tokens = 0;

  // Getters
  List<InventoryItem> get items => _items;
  Map<String, InventoryItem> get equipment => _equipment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get maxSlots => _maxSlots;
  int get usedSlots => _items.fold(0, (sum, item) => sum + 1);
  int get availableSlots => _maxSlots - usedSlots;
  int get gold => _gold;
  int get gems => _gems;
  int get tokens => _tokens;

  Future<void> initialize() async {
    await loadInventory();
    await _loadCurrency();
  }

  Future<void> loadInventory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final inventoryData = await inventoryService.getInventory();
      _items = inventoryData.items;
      _equipment = inventoryData.equipment;
      _maxSlots = inventoryData.maxSlots;
    } catch (e) {
      _error = 'Failed to load inventory: $e';
      // Load from local storage as fallback
      await _loadFromLocalStorage();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getString('inventory_items');
      final equipmentJson = prefs.getString('inventory_equipment');

      if (itemsJson != null) {
        final List<dynamic> itemsList = jsonDecode(itemsJson);
        _items = itemsList.map((json) => InventoryItem.fromJson(json)).toList();
      }

      if (equipmentJson != null) {
        final Map<String, dynamic> equipmentMap = jsonDecode(equipmentJson);
        _equipment = equipmentMap.map(
          (key, value) => MapEntry(key, InventoryItem.fromJson(value)),
        );
      }
    } catch (e) {
      // Initialize with default items if all else fails
      _initializeWithDefaultItems();
    }
  }

  void _initializeWithDefaultItems() {
    _items = [
      InventoryItem(
        itemId: 'basic_sword',
        name: 'Basic Sword',
        type: 'weapon',
        rarity: ItemRarity.common,
        quantity: 1,
        stats: {'attack': 10},
        description: 'A simple iron sword',
        obtainedAt: DateTime.now(),
      ),
      InventoryItem(
        itemId: 'health_potion',
        name: 'Health Potion',
        type: 'consumable',
        rarity: ItemRarity.common,
        quantity: 5,
        stats: {'healing': 50},
        description: 'Restores 50 HP',
        obtainedAt: DateTime.now(),
      ),
      InventoryItem(
        itemId: 'wood',
        name: 'Wood',
        type: 'material',
        rarity: ItemRarity.common,
        quantity: 10,
        description: 'Basic crafting material',
        obtainedAt: DateTime.now(),
      ),
    ];
  }

  Future<void> _loadCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _gold = prefs.getInt('currency_gold') ?? 100;
      _gems = prefs.getInt('currency_gems') ?? 10;
      _tokens = prefs.getInt('currency_tokens') ?? 0;
    } catch (e) {
      // Default currency values
      _gold = 100;
      _gems = 10;
      _tokens = 0;
    }
  }

  Future<void> _saveCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currency_gold', _gold);
      await prefs.setInt('currency_gems', _gems);
      await prefs.setInt('currency_tokens', _tokens);
    } catch (e) {
      print('Failed to save currency: $e');
    }
  }

  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final itemsJson = jsonEncode(
        _items.map((item) => item.toJson()).toList(),
      );
      final equipmentJson = jsonEncode(
        _equipment.map((key, item) => MapEntry(key, item.toJson())),
      );

      await prefs.setString('inventory_items', itemsJson);
      await prefs.setString('inventory_equipment', equipmentJson);
    } catch (e) {
      print('Failed to save inventory to local storage: $e');
    }
  }

  Future<bool> addItem(InventoryItem newItem) async {
    if (availableSlots <= 0 && !hasItem(newItem.itemId)) {
      _error = 'Inventory is full!';
      notifyListeners();
      return false;
    }

    try {
      // Check if item already exists (for stackable items)
      final existingIndex = _items.indexWhere(
        (item) => item.itemId == newItem.itemId && !_isUniqueItem(newItem),
      );

      if (existingIndex != -1) {
        // Stack with existing item
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity + newItem.quantity,
        );
      } else {
        // Add as new item
        _items.add(newItem);
      }

      await _saveToLocalStorage();
      await inventoryService.syncInventory(_items, _equipment);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add item: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeItem(String itemId, int quantity) async {
    final itemIndex = _items.indexWhere((item) => item.itemId == itemId);
    if (itemIndex == -1) {
      _error = 'Item not found!';
      notifyListeners();
      return false;
    }

    try {
      final item = _items[itemIndex];

      if (item.quantity <= quantity) {
        // Remove entire item
        _items.removeAt(itemIndex);
      } else {
        // Reduce quantity
        _items[itemIndex] = item.copyWith(quantity: item.quantity - quantity);
      }

      await _saveToLocalStorage();
      await inventoryService.syncInventory(_items, _equipment);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to remove item: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> equipItem(String itemId, String slot) async {
    final item = _items.firstWhere((item) => item.itemId == itemId);

    try {
      // Unequip current item in slot if exists
      if (_equipment.containsKey(slot)) {
        final currentEquipped = _equipment[slot]!;
        final unequippedItem = currentEquipped.copyWith(isEquipped: false);
        await addItem(unequippedItem);
      }

      // Equip new item
      _equipment[slot] = item.copyWith(isEquipped: true);

      // Remove from inventory
      await removeItem(itemId, 1);

      await _saveToLocalStorage();
      await inventoryService.syncInventory(_items, _equipment);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to equip item: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> unequipItem(String slot) async {
    if (!_equipment.containsKey(slot)) {
      _error = 'No item equipped in that slot!';
      notifyListeners();
      return false;
    }

    try {
      final equippedItem = _equipment[slot]!;
      _equipment.remove(slot);

      // Add back to inventory
      await addItem(equippedItem.copyWith(isEquipped: false));

      await _saveToLocalStorage();
      await inventoryService.syncInventory(_items, _equipment);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to unequip item: $e';
      notifyListeners();
      return false;
    }
  }

  bool hasItem(String itemId, [int requiredQuantity = 1]) {
    final item = _items.firstWhere(
      (item) => item.itemId == itemId,
      orElse: () => InventoryItem(
        itemId: '',
        name: '',
        type: '',
        rarity: ItemRarity.common,
        quantity: 0,
        obtainedAt: DateTime.now(),
      ),
    );

    return item.quantity >= requiredQuantity;
  }

  int getItemQuantity(String itemId) {
    final item = _items.firstWhere(
      (item) => item.itemId == itemId,
      orElse: () => InventoryItem(
        itemId: '',
        name: '',
        type: '',
        rarity: ItemRarity.common,
        quantity: 0,
        obtainedAt: DateTime.now(),
      ),
    );

    return item.quantity;
  }

  List<InventoryItem> getItemsByType(String type) {
    return _items
        .where((item) => item.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  List<InventoryItem> getResourceItems() {
    final resourceTypes = [
      'material',
      'resource',
      'wood',
      'stone',
      'metal',
      'crystal',
    ];
    return _items
        .where((item) => resourceTypes.contains(item.type.toLowerCase()))
        .toList();
  }

  List<InventoryItem> getConsumableItems() {
    return _items
        .where((item) => item.type.toLowerCase() == 'consumable')
        .toList();
  }

  List<InventoryItem> getEquipmentItems() {
    final equipmentTypes = ['weapon', 'armor', 'helmet', 'boots', 'accessory'];
    return _items
        .where((item) => equipmentTypes.contains(item.type.toLowerCase()))
        .toList();
  }

  void addCurrency({int gold = 0, int gems = 0, int tokens = 0}) {
    _gold += gold;
    _gems += gems;
    _tokens += tokens;
    _saveCurrency();
    notifyListeners();
  }

  bool spendCurrency({int gold = 0, int gems = 0, int tokens = 0}) {
    if (_gold < gold || _gems < gems || _tokens < tokens) {
      _error = 'Insufficient currency!';
      notifyListeners();
      return false;
    }

    _gold -= gold;
    _gems -= gems;
    _tokens -= tokens;
    _saveCurrency();
    notifyListeners();
    return true;
  }

  Future<bool> useConsumableItem(String itemId) async {
    final item = _items.firstWhere(
      (item) =>
          item.itemId == itemId && item.type.toLowerCase() == 'consumable',
      orElse: () => InventoryItem(
        itemId: '',
        name: '',
        type: '',
        rarity: ItemRarity.common,
        quantity: 0,
        obtainedAt: DateTime.now(),
      ),
    );

    if (item.quantity <= 0) {
      _error = 'Item not available!';
      notifyListeners();
      return false;
    }

    // Apply item effects (this would typically integrate with game systems)
    _applyItemEffects(item);

    // Remove one from inventory
    await removeItem(itemId, 1);

    return true;
  }

  void _applyItemEffects(InventoryItem item) {
    // This would typically integrate with player stats, combat system, etc.
    // For now, just show a message
    print('Used ${item.name}: ${item.description}');

    // Example effects based on stats
    if (item.stats.containsKey('healing')) {
      print('Healed ${item.stats['healing']} HP');
    }
    if (item.stats.containsKey('mana_restore')) {
      print('Restored ${item.stats['mana_restore']} MP');
    }
  }

  double getTotalWeight() {
    return _items.fold(0.0, (total, item) {
      final weight = item.stats['weight']?.toDouble() ?? 1.0;
      return total + (weight * item.quantity);
    });
  }

  Map<ItemRarity, int> getRarityDistribution() {
    final distribution = <ItemRarity, int>{
      ItemRarity.common: 0,
      ItemRarity.uncommon: 0,
      ItemRarity.rare: 0,
      ItemRarity.epic: 0,
      ItemRarity.legendary: 0,
    };

    for (final item in _items) {
      distribution[item.rarity] = (distribution[item.rarity] ?? 0) + 1;
    }

    return distribution;
  }

  List<InventoryItem> searchItems(String query) {
    final lowerQuery = query.toLowerCase();
    return _items
        .where(
          (item) =>
              item.name.toLowerCase().contains(lowerQuery) ||
              item.type.toLowerCase().contains(lowerQuery) ||
              (item.description?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  void sortItems(String sortBy) {
    switch (sortBy.toLowerCase()) {
      case 'name':
        _items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'type':
        _items.sort((a, b) => a.type.compareTo(b.type));
        break;
      case 'rarity':
        _items.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
        break;
      case 'quantity':
        _items.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case 'date':
        _items.sort((a, b) => b.obtainedAt.compareTo(a.obtainedAt));
        break;
    }
    notifyListeners();
  }

  bool _isUniqueItem(InventoryItem item) {
    // Items like weapons and armor are usually unique (not stackable)
    final uniqueTypes = ['weapon', 'armor', 'helmet', 'boots', 'accessory'];
    return uniqueTypes.contains(item.type.toLowerCase()) ||
        item.rarity == ItemRarity.legendary ||
        item.rarity == ItemRarity.epic;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadInventory();
  }

  @override
  void dispose() {
    _saveToLocalStorage();
    super.dispose();
  }
}
