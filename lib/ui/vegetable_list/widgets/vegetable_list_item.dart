import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/vegetable.dart';

class VegetableListItem extends StatelessWidget {
  final Vegetable vegetable;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VegetableListItem({
    super.key,
    required this.vegetable,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('MMM d, y h:mm a');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('vegetable_${index}_${vegetable.name}'),
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
        title: Text(vegetable.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created: ${_formatDateTime(vegetable.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Updated: ${_formatDateTime(vegetable.lastUpdatedAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        isThreeLine: true,
        onLongPress: onEdit,
      ),
    );
  }
}
