import 'package:flutter/material.dart';
import '../models/vegetable.dart';

Future<Map<String, dynamic>?> showAddVegetableDialog(
  BuildContext context, {
  HarvestState defaultHarvestState = HarvestState.scarce,
}) async {
  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => _AddVegetableDialog(
      defaultHarvestState: defaultHarvestState,
    ),
  );
}

class _AddVegetableDialog extends StatefulWidget {
  final HarvestState defaultHarvestState;

  const _AddVegetableDialog({
    required this.defaultHarvestState,
  });

  @override
  State<_AddVegetableDialog> createState() => _AddVegetableDialogState();
}

class _AddVegetableDialogState extends State<_AddVegetableDialog> {
  late final TextEditingController _controller;
  late HarvestState _selectedState;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedState = widget.defaultHarvestState;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Vegetable'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Vegetable Name',
              hintText: 'Enter vegetable name',
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<HarvestState>(
            initialValue: _selectedState,
            decoration: const InputDecoration(
              labelText: 'Harvest State',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: HarvestState.scarce,
                child: Text('Scarce 🌱'),
              ),
              DropdownMenuItem(
                value: HarvestState.enough,
                child: Text('Enough 🌿'),
              ),
              DropdownMenuItem(
                value: HarvestState.plenty,
                child: Text('Plenty 🌾'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedState = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.pop(context, {
                'name': value,
                'harvestState': _selectedState,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
