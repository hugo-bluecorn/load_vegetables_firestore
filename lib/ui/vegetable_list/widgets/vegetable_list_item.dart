import 'package:flutter/material.dart';

class VegetableListItem extends StatelessWidget {
  final String vegetableName;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VegetableListItem({
    super.key,
    required this.vegetableName,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.eco,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(vegetableName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
