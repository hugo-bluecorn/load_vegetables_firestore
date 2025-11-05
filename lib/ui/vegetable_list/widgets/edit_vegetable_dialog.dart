import 'package:flutter/material.dart';

Future<String?> showEditVegetableDialog(
  BuildContext context,
  String currentName,
) async {
  final controller = TextEditingController(text: currentName);
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Vegetable'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Vegetable Name'),
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
          child: const Text('Save'),
        ),
      ],
    ),
  );

  return result;
}
