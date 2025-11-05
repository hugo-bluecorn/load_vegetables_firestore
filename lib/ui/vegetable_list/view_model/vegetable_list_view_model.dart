import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vegetable.dart';

class VegetableService {
  static const String _storageKey = 'vegetables';

  /// Load all vegetables from local storage
  Future<List<Vegetable>> loadVegetables() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to get as String (new format)
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      // New format: JSON string
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => VegetableMapper.fromMap(json as Map<String, dynamic>))
          .toList();
    }

    // Check for old format: List<String>
    final oldFormatList = prefs.getStringList(_storageKey);
    if (oldFormatList != null && oldFormatList.isNotEmpty) {
      // Migrate old data to new format
      final vegetables = oldFormatList
          .map((name) => Vegetable(name: name))
          .toList();

      // Save in new format
      await saveVegetables(vegetables);

      return vegetables;
    }

    // No data exists, return empty list
    return [];
  }

  /// Save vegetables list to local storage
  Future<void> saveVegetables(List<Vegetable> vegetables) async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize to JSON string
    final jsonList = vegetables.map((v) => v.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_storageKey, jsonString);
  }

  /// Add a new vegetable
  Future<void> addVegetable(Vegetable vegetable) async {
    final vegetables = await loadVegetables();
    vegetables.add(vegetable);
    await saveVegetables(vegetables);
  }

  /// Update a vegetable at the given index
  Future<void> updateVegetable(int index, Vegetable newValue) async {
    final vegetables = await loadVegetables();
    if (index >= 0 && index < vegetables.length) {
      vegetables[index] = newValue;
      await saveVegetables(vegetables);
    }
  }

  /// Delete a vegetable at the given index
  Future<void> deleteVegetable(int index) async {
    final vegetables = await loadVegetables();
    if (index >= 0 && index < vegetables.length) {
      vegetables.removeAt(index);
      await saveVegetables(vegetables);
    }
  }

  /// Import vegetables from a list, skipping duplicates
  /// Returns the number of vegetables actually imported
  /// New vegetables are created with default harvest state (scarce)
  Future<int> importVegetables(List<String> newVegetables) async {
    final existingVegetables = await loadVegetables();

    // Create a case-insensitive set of existing vegetable names for comparison
    final existingLowerCase = existingVegetables
        .map((v) => v.name.toLowerCase().trim())
        .toSet();

    int importedCount = 0;

    for (final vegetable in newVegetables) {
      final trimmed = vegetable.trim();
      if (trimmed.isEmpty) continue;

      // Skip if duplicate (case-insensitive)
      if (existingLowerCase.contains(trimmed.toLowerCase())) {
        continue;
      }

      existingVegetables.add(Vegetable(name: trimmed));
      existingLowerCase.add(trimmed.toLowerCase());
      importedCount++;
    }

    if (importedCount > 0) {
      await saveVegetables(existingVegetables);
    }

    return importedCount;
  }
}
