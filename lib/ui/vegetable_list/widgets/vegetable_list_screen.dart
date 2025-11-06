import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vegetable.dart';
import '../providers/vegetable_providers.dart';
import 'add_vegetable_dialog.dart';
import 'delete_vegetable_dialog.dart';
import 'edit_vegetable_dialog.dart';
import 'import_button.dart';
import 'vegetables_list_view.dart';

class VegetablesListScreen extends ConsumerWidget {
  final HarvestState harvestState;

  const VegetablesListScreen({required this.harvestState, super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showAddVegetableDialog(
      context,
      defaultHarvestState: harvestState,
    );

    if (result != null) {
      await ref
          .read(vegetablesProvider.notifier)
          .add(
            Vegetable(
              name: result['name'] as String,
              harvestState: result['harvestState'] as HarvestState,
            ),
          );
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    Vegetable currentVegetable,
  ) async {
    final result = await showEditVegetableDialog(context, currentVegetable);

    if (result != null) {
      await ref
          .read(vegetablesProvider.notifier)
          .updateVegetable(
            index,
            currentVegetable.copyWith(
              name: result['name'] as String,
              harvestState: result['harvestState'] as HarvestState,
              lastUpdatedAt: DateTime.now(),
            ),
          );
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    Vegetable vegetable,
  ) async {
    final confirmed = await showDeleteVegetableDialog(context, vegetable.name);

    if (confirmed == true) {
      await ref.read(vegetablesProvider.notifier).delete(index);
    }
  }

  String _getTitle() {
    switch (harvestState) {
      case HarvestState.scarce:
        return 'Vegetables - Scarce';
      case HarvestState.enough:
        return 'Vegetables - Enough';
      case HarvestState.plenty:
        return 'Vegetables - Plenty';
    }
  }

  Color _getThemeColor() {
    switch (harvestState) {
      case HarvestState.plenty:
        return Colors.amber; // Yellow
      case HarvestState.enough:
        return Colors.blue;
      case HarvestState.scarce:
        return Colors.deepPurple; // Purple
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vegetablesAsync = ref.watch(vegetablesProvider);
    final themeColor = _getThemeColor();

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          actions: const [ImportButton()],
        ),
        body: vegetablesAsync.when(
          data: (vegetables) {
            // Filter vegetables by harvest state
            final filteredVegetables = vegetables
                .where((v) => v.harvestState == harvestState)
                .toList();

            return VegetablesListView(
              isLoading: false,
              vegetables: filteredVegetables,
              onEdit: (index) {
                // Find the actual index in the full vegetables list
                final actualIndex = vegetables.indexOf(
                  filteredVegetables[index],
                );
                return _showEditDialog(
                  context,
                  ref,
                  actualIndex,
                  filteredVegetables[index],
                );
              },
              onDelete: (index) {
                // Find the actual index in the full vegetables list
                final actualIndex = vegetables.indexOf(
                  filteredVegetables[index],
                );
                return _showDeleteDialog(
                  context,
                  ref,
                  actualIndex,
                  filteredVegetables[index],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Error loading vegetables',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(vegetablesProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context, ref),
          tooltip: 'Add Vegetable',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
