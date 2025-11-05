import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vegetable_providers.dart';
import 'add_vegetable_dialog.dart';
import 'delete_vegetable_dialog.dart';
import 'edit_vegetable_dialog.dart';
import 'import_button.dart';
import 'vegetables_list_view.dart';

class VegetablesListScreen extends ConsumerWidget {
  const VegetablesListScreen({super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showAddVegetableDialog(context);

    if (result != null && result.isNotEmpty) {
      await ref.read(vegetablesProvider.notifier).add(result);
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    String currentName,
  ) async {
    final result = await showEditVegetableDialog(context, currentName);

    if (result != null && result.isNotEmpty) {
      await ref.read(vegetablesProvider.notifier).updateVegetable(index, result);
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    String name,
  ) async {
    final confirmed = await showDeleteVegetableDialog(context, name);

    if (confirmed == true) {
      await ref.read(vegetablesProvider.notifier).delete(index);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vegetablesAsync = ref.watch(vegetablesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetables'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          ImportButton(),
        ],
      ),
      body: vegetablesAsync.when(
        data: (vegetables) => VegetablesListView(
          isLoading: false,
          vegetables: vegetables,
          onEdit: (index) => _showEditDialog(
            context,
            ref,
            index,
            vegetables[index],
          ),
          onDelete: (index) => _showDeleteDialog(
            context,
            ref,
            index,
            vegetables[index],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
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
    );
  }
}
