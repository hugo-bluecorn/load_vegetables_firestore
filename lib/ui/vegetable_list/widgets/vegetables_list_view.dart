import 'package:flutter/material.dart';
import '../models/vegetable.dart';
import 'vegetable_list_item.dart';

class VegetablesListView extends StatelessWidget {
  final bool isLoading;
  final List<Vegetable> vegetables;
  final Function(int) onDelete;
  final bool isSelectionMode;
  final Set<Vegetable> selectedVegetables;
  final Function(int)? onItemTap;
  final Function(int)? onItemLongPress;

  const VegetablesListView({
    super.key,
    required this.isLoading,
    required this.vegetables,
    required this.onDelete,
    this.isSelectionMode = false,
    this.selectedVegetables = const {},
    this.onItemTap,
    this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vegetables.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No vegetables yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a vegetable',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: vegetables.length,
      itemBuilder: (context, index) {
        final vegetable = vegetables[index];
        return VegetableListItem(
          vegetable: vegetable,
          index: index,
          onDelete: () => onDelete(index),
          isSelectionMode: isSelectionMode,
          isSelected: selectedVegetables.contains(vegetable),
          onTap: onItemTap != null ? () => onItemTap!(index) : null,
          onLongPress: onItemLongPress != null ? () => onItemLongPress!(index) : null,
        );
      },
    );
  }
}
