import 'package:flutter/material.dart';

Future<bool?> showDeleteVegetableDialog(
  BuildContext context,
  String vegetableName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Vegetable'),
      content: Text(
        'Are you sure you want to delete "$vegetableName"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  return confirmed;
}
