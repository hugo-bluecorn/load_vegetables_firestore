import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vegetable.dart';
import '../providers/vegetable_providers.dart';
import 'add_vegetable_dialog.dart';
import 'delete_vegetable_dialog.dart';
import 'edit_vegetable_dialog.dart';
import 'move_vegetables_dialog.dart';
import 'vegetables_list_view.dart';

class VegetablesListScreen extends ConsumerStatefulWidget {
  final HarvestState harvestState;

  const VegetablesListScreen({required this.harvestState, super.key});

  @override
  ConsumerState<VegetablesListScreen> createState() =>
      _VegetablesListScreenState();
}

class _VegetablesListScreenState extends ConsumerState<VegetablesListScreen> {
  bool _isSelectionMode = false;
  final Set<Vegetable> _selectedVegetables = {};

  void _enterSelectionMode(Vegetable vegetable) {
    setState(() {
      _isSelectionMode = true;
      _selectedVegetables.clear();
      _selectedVegetables.add(vegetable);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedVegetables.clear();
    });
  }

  void _toggleSelection(Vegetable vegetable) {
    setState(() {
      if (_selectedVegetables.contains(vegetable)) {
        _selectedVegetables.remove(vegetable);
        // Exit selection mode if no items are selected
        if (_selectedVegetables.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedVegetables.add(vegetable);
      }
    });
  }

  void _handleItemLongPress(List<Vegetable> vegetables, int index) {
    _enterSelectionMode(vegetables[index]);
  }

  void _handleItemTap(List<Vegetable> vegetables, int index) {
    if (_isSelectionMode) {
      _toggleSelection(vegetables[index]);
    }
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final result = await showAddVegetableDialog(
      context,
      defaultHarvestState: widget.harvestState,
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

  Future<void> _showDeleteDialog(
    BuildContext context,
    int index,
    Vegetable vegetable,
  ) async {
    final confirmed = await showDeleteVegetableDialog(context, vegetable.name);

    if (confirmed == true) {
      await ref.read(vegetablesProvider.notifier).delete(index);
    }
  }

  Future<void> _handleSelectionEdit(
    BuildContext context,
    List<Vegetable> allVegetables,
  ) async {
    if (_selectedVegetables.length != 1) return;

    final selectedVeg = _selectedVegetables.first;
    final actualIndex = allVegetables.indexOf(selectedVeg);

    final result = await showEditVegetableDialog(context, selectedVeg);

    if (result != null) {
      await ref.read(vegetablesProvider.notifier).updateVegetable(
            actualIndex,
            selectedVeg.copyWith(
              name: result['name'] as String,
              harvestState: result['harvestState'] as HarvestState,
              lastUpdatedAt: DateTime.now(),
            ),
          );
      _exitSelectionMode();
    }
  }

  Future<void> _handleSelectionDelete(
    BuildContext context,
    List<Vegetable> allVegetables,
  ) async {
    if (_selectedVegetables.isEmpty) return;

    // Show confirmation dialog
    final count = _selectedVegetables.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vegetables'),
        content: Text('Are you sure you want to delete $count vegetable(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Delete all selected vegetables
      // Note: We'll need to add deleteMultiple to the notifier
      await ref
          .read(vegetablesProvider.notifier)
          .deleteMultiple(_selectedVegetables.toList());
      _exitSelectionMode();
    }
  }

  Future<void> _handleSelectionMove(BuildContext context) async {
    if (_selectedVegetables.isEmpty) return;

    final targetState = await showMoveVegetablesDialog(
      context,
      count: _selectedVegetables.length,
      currentState: widget.harvestState,
    );

    if (targetState != null) {
      await ref
          .read(vegetablesProvider.notifier)
          .updateHarvestStateForMultiple(
            _selectedVegetables.toList(),
            targetState,
          );
      _exitSelectionMode();
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    try {
      // Pick a text file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not read file path'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Read the file line by line
      final file = File(filePath);
      final lines = await file.readAsLines();

      // Filter out empty lines and import
      final vegetables = lines
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (vegetables.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No vegetables found in file'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Import vegetables using Riverpod notifier
      final importedCount =
          await ref.read(vegetablesProvider.notifier).import(vegetables);

      // Show feedback
      if (context.mounted) {
        final totalInFile = vegetables.length;
        final skippedCount = totalInFile - importedCount;
        final message = importedCount == 0
            ? 'No new vegetables to import (all duplicates)'
            : skippedCount == 0
                ? 'Imported $importedCount vegetables'
                : 'Imported $importedCount vegetables ($skippedCount duplicates skipped)';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: importedCount > 0 ? Colors.green : null,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getTitle() {
    if (_isSelectionMode) {
      return '${_selectedVegetables.length} selected';
    }
    switch (widget.harvestState) {
      case HarvestState.scarce:
        return 'Vegetables - Scarce';
      case HarvestState.enough:
        return 'Vegetables - Enough';
      case HarvestState.plenty:
        return 'Vegetables - Plenty';
    }
  }

  Color _getThemeColor() {
    switch (widget.harvestState) {
      case HarvestState.plenty:
        return Colors.amber; // Yellow
      case HarvestState.enough:
        return Colors.blue;
      case HarvestState.scarce:
        return Colors.deepPurple; // Purple
    }
  }

  List<Widget> _buildAppBarActions(List<Vegetable> allVegetables) {
    if (_isSelectionMode) {
      return [
        // Edit action - only enabled if exactly 1 item is selected
        IconButton(
          onPressed: _selectedVegetables.length == 1
              ? () => _handleSelectionEdit(context, allVegetables)
              : null,
          icon: const Icon(Icons.edit),
          tooltip: 'Edit',
        ),
        // Delete action
        IconButton(
          onPressed: () => _handleSelectionDelete(context, allVegetables),
          icon: const Icon(Icons.delete),
          tooltip: 'Delete',
        ),
        // Move action
        IconButton(
          onPressed: () => _handleSelectionMove(context),
          icon: const Icon(Icons.drive_file_move),
          tooltip: 'Move to different harvest state',
        ),
      ];
    }
    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        tooltip: 'More options',
        onSelected: (value) {
          if (value == 'add') {
            _showAddDialog(context);
          } else if (value == 'import') {
            _handleImport(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'add',
            child: Row(
              children: [
                Icon(Icons.add_circle_outline, size: 20, color: Colors.grey[800]),
                const SizedBox(width: 12),
                Expanded(child: const Text('Add vegetable')),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'import',
            child: Row(
              children: [
                Icon(Icons.upload_file, size: 20, color: Colors.grey[800]),
                const SizedBox(width: 12),
                Expanded(child: const Text('Import from file')),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final vegetablesAsync = ref.watch(vegetablesProvider);
    final themeColor = _getThemeColor();

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSelectionMode) {
          _exitSelectionMode();
        }
      },
      child: Theme(
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
            leading: _isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _exitSelectionMode,
                  )
                : null,
            actions: vegetablesAsync.maybeWhen(
              data: (vegetables) => _buildAppBarActions(vegetables),
              orElse: () => const [],
            ),
          ),
          body: vegetablesAsync.when(
            data: (vegetables) {
              // Filter vegetables by harvest state
              final filteredVegetables = vegetables
                  .where((v) => v.harvestState == widget.harvestState)
                  .toList();

              return VegetablesListView(
                isLoading: false,
                vegetables: filteredVegetables,
                isSelectionMode: _isSelectionMode,
                selectedVegetables: _selectedVegetables,
                onItemTap: (index) => _handleItemTap(filteredVegetables, index),
                onItemLongPress: (index) =>
                    _handleItemLongPress(filteredVegetables, index),
                onDelete: (index) {
                  // Find the actual index in the full vegetables list
                  final actualIndex = vegetables.indexOf(
                    filteredVegetables[index],
                  );
                  return _showDeleteDialog(
                    context,
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
        ),
      ),
    );
  }
}
