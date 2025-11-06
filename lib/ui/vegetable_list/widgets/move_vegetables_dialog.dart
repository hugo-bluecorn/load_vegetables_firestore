import 'package:flutter/material.dart';
import '../models/vegetable.dart';

Future<HarvestState?> showMoveVegetablesDialog(
  BuildContext context, {
  required int count,
  HarvestState? currentState,
}) async {
  return await showDialog<HarvestState>(
    context: context,
    builder: (context) => _MoveVegetablesDialog(
      count: count,
      currentState: currentState,
    ),
  );
}

class _MoveVegetablesDialog extends StatefulWidget {
  final int count;
  final HarvestState? currentState;

  const _MoveVegetablesDialog({
    required this.count,
    this.currentState,
  });

  @override
  State<_MoveVegetablesDialog> createState() => _MoveVegetablesDialogState();
}

class _MoveVegetablesDialogState extends State<_MoveVegetablesDialog> {
  late HarvestState _selectedState;

  @override
  void initState() {
    super.initState();
    // Default to the first available state different from current
    _selectedState = widget.currentState ?? HarvestState.plenty;
  }

  String _getEmoji(HarvestState state) {
    switch (state) {
      case HarvestState.scarce:
        return '🌱';
      case HarvestState.enough:
        return '🌿';
      case HarvestState.plenty:
        return '🌾';
    }
  }

  String _getStateLabel(HarvestState state) {
    switch (state) {
      case HarvestState.scarce:
        return 'Scarce';
      case HarvestState.enough:
        return 'Enough';
      case HarvestState.plenty:
        return 'Plenty';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Move ${widget.count} Vegetable${widget.count > 1 ? 's' : ''}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select the target harvest state:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<HarvestState>(
            initialValue: _selectedState,
            decoration: const InputDecoration(
              labelText: 'Target Harvest State',
              border: OutlineInputBorder(),
            ),
            items: HarvestState.values.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text('${_getStateLabel(state)} ${_getEmoji(state)}'),
              );
            }).toList(),
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
          onPressed: () => Navigator.pop(context, _selectedState),
          child: const Text('Move'),
        ),
      ],
    );
  }
}
