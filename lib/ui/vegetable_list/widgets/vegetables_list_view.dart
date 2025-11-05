import 'package:flutter/material.dart';
import 'vegetable_list_item.dart';

class VegetablesListView extends StatelessWidget {
  final bool isLoading;
  final List<String> vegetables;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const VegetablesListView({
    super.key,
    required this.isLoading,
    required this.vegetables,
    required this.onEdit,
    required this.onDelete,
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
        return VegetableListItem(
          vegetableName: vegetables[index],
          index: index,
          onEdit: () => onEdit(index),
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}
