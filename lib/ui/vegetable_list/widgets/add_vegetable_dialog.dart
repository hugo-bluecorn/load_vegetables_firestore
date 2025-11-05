import 'package:flutter/material.dart';

Future<String?> showAddVegetableDialog(BuildContext context) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Vegetable'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Vegetable Name',
          hintText: 'Enter vegetable name',
        ),
        textCapitalization: TextCapitalization.words,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );

  return result;
}
