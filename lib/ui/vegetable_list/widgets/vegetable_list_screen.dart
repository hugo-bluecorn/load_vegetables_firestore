import 'package:flutter/material.dart';
import '../view_model/vegetable_list_view_model.dart';
import 'add_vegetable_dialog.dart';
import 'delete_vegetable_dialog.dart';
import 'edit_vegetable_dialog.dart';
import 'import_button.dart';
import 'vegetables_list_view.dart';

class VegetablesListScreen extends StatefulWidget {
  const VegetablesListScreen({super.key});

  @override
  State<VegetablesListScreen> createState() => _VegetablesListScreenState();
}

class _VegetablesListScreenState extends State<VegetablesListScreen> {
  final VegetableService _service = VegetableService();
  List<String> _vegetables = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVegetables();
  }

  Future<void> _loadVegetables() async {
    setState(() => _isLoading = true);
    final vegetables = await _service.loadVegetables();
    setState(() {
      _vegetables = vegetables;
      _isLoading = false;
    });
  }

  Future<void> _showAddDialog() async {
    final result = await showAddVegetableDialog(context);

    if (result != null && result.isNotEmpty) {
      await _service.addVegetable(result);
      await _loadVegetables();
    }
  }

  Future<void> _showEditDialog(int index) async {
    final result = await showEditVegetableDialog(context, _vegetables[index]);

    if (result != null && result.isNotEmpty) {
      await _service.updateVegetable(index, result);
      await _loadVegetables();
    }
  }

  Future<void> _showDeleteDialog(int index) async {
    final confirmed =
        await showDeleteVegetableDialog(context, _vegetables[index]);

    if (confirmed == true) {
      await _service.deleteVegetable(index);
      await _loadVegetables();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetables'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          ImportButton(
            service: _service,
            onImportComplete: _loadVegetables,
          ),
        ],
      ),
      body: VegetablesListView(
        isLoading: _isLoading,
        vegetables: _vegetables,
        onEdit: _showEditDialog,
        onDelete: _showDeleteDialog,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add Vegetable',
        child: const Icon(Icons.add),
      ),
    );
  }
}
