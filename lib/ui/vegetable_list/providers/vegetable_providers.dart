import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vegetable.dart';
import '../view_model/vegetable_list_view_model.dart';

/// Provider for the VegetableService singleton
final vegetableServiceProvider = Provider<VegetableService>((ref) {
  return VegetableService();
});

/// Notifier for managing vegetables state with AsyncValue
class VegetablesNotifier extends AsyncNotifier<List<Vegetable>> {
  @override
  Future<List<Vegetable>> build() async {
    // Initial load of vegetables
    final service = ref.read(vegetableServiceProvider);
    return await service.loadVegetables();
  }

  /// Add a new vegetable to the list
  Future<void> add(Vegetable vegetable) async {
    if (vegetable.name.trim().isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vegetableServiceProvider);
      await service.addVegetable(vegetable);
      return await service.loadVegetables();
    });
  }

  /// Update a vegetable at the given index
  Future<void> updateVegetable(int index, Vegetable newValue) async {
    if (newValue.name.trim().isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vegetableServiceProvider);
      await service.updateVegetable(index, newValue);
      return await service.loadVegetables();
    });
  }

  /// Delete a vegetable at the given index
  Future<void> delete(int index) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vegetableServiceProvider);
      await service.deleteVegetable(index);
      return await service.loadVegetables();
    });
  }

  /// Import vegetables from a list
  /// Returns the number of vegetables imported
  Future<int> import(List<String> vegetables) async {
    state = const AsyncLoading();

    int importedCount = 0;
    state = await AsyncValue.guard(() async {
      final service = ref.read(vegetableServiceProvider);
      importedCount = await service.importVegetables(vegetables);
      return await service.loadVegetables();
    });

    return importedCount;
  }

  /// Refresh the vegetables list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vegetableServiceProvider);
      return await service.loadVegetables();
    });
  }
}

/// Provider for the vegetables state
final vegetablesProvider =
    AsyncNotifierProvider<VegetablesNotifier, List<Vegetable>>(() {
  return VegetablesNotifier();
});
