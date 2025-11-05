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
    return Dismissible(
      key: Key('vegetable_${index}_$vegetableName'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        // Call the onDelete callback which handles showing the dialog
        // and return the result to determine if dismissal should proceed
        onDelete();
        // Return false to prevent automatic dismissal
        // The parent will handle the actual deletion if confirmed
        return false;
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.eco, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(vegetableName),
        onLongPress: onEdit,
      ),
    );
  }
}
