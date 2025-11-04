import 'package:shared_preferences/shared_preferences.dart';

class VegetableService {
  static const String _storageKey = 'vegetables';

  /// Load all vegetables from local storage
  Future<List<String>> loadVegetables() async {
    final prefs = await SharedPreferences.getInstance();
    final vegetables = prefs.getStringList(_storageKey);

    // If no data exists, return empty list
    if (vegetables == null || vegetables.isEmpty) {
      return [];
    }

    return vegetables;
  }

  /// Save vegetables list to local storage
  Future<void> saveVegetables(List<String> vegetables) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, vegetables);
  }

  /// Add a new vegetable
  Future<void> addVegetable(String vegetable) async {
    final vegetables = await loadVegetables();
    vegetables.add(vegetable);
    await saveVegetables(vegetables);
  }

  /// Update a vegetable at the given index
  Future<void> updateVegetable(int index, String newValue) async {
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
  Future<int> importVegetables(List<String> newVegetables) async {
    final existingVegetables = await loadVegetables();

    // Create a case-insensitive set of existing vegetables for comparison
    final existingLowerCase = existingVegetables
        .map((v) => v.toLowerCase().trim())
        .toSet();

    int importedCount = 0;

    for (final vegetable in newVegetables) {
      final trimmed = vegetable.trim();
      if (trimmed.isEmpty) continue;

      // Skip if duplicate (case-insensitive)
      if (existingLowerCase.contains(trimmed.toLowerCase())) {
        continue;
      }

      existingVegetables.add(trimmed);
      existingLowerCase.add(trimmed.toLowerCase());
      importedCount++;
    }

    if (importedCount > 0) {
      await saveVegetables(existingVegetables);
    }

    return importedCount;
  }
}
