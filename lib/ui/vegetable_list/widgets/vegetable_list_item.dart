import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/vegetable.dart';

class VegetableListItem extends StatelessWidget {
  final Vegetable vegetable;
  final int index;
  final VoidCallback onDelete;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const VegetableListItem({
    super.key,
    required this.vegetable,
    required this.index,
    required this.onDelete,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('MMM d, y h:mm a');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final listTile = ListTile(
      leading: isSelectionMode
          ? Checkbox(
              value: isSelected,
              onChanged: onTap != null ? (_) => onTap!() : null,
            )
          : CircleAvatar(
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
      onTap: isSelectionMode ? onTap : null,
      onLongPress: onLongPress,
    );

    // Disable swipe when in selection mode
    if (isSelectionMode) {
      return listTile;
    }

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
      child: listTile,
    );
  }
}
