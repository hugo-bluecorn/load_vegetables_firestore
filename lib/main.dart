import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'services/vegetable_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetables List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const VegetablesListPage(),
    );
  }
}

class VegetablesListPage extends StatefulWidget {
  const VegetablesListPage({super.key});

  @override
  State<VegetablesListPage> createState() => _VegetablesListPageState();
}

class _VegetablesListPageState extends State<VegetablesListPage> {
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

    if (result != null && result.isNotEmpty) {
      await _service.addVegetable(result);
      await _loadVegetables();
    }
  }

  Future<void> _showEditDialog(int index) async {
    final controller = TextEditingController(text: _vegetables[index]);
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

    if (result != null && result.isNotEmpty) {
      await _service.updateVegetable(index, result);
      await _loadVegetables();
    }
  }

  Future<void> _showDeleteDialog(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vegetable'),
        content: Text(
          'Are you sure you want to delete "${_vegetables[index]}"?',
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

    if (confirmed == true) {
      await _service.deleteVegetable(index);
      await _loadVegetables();
    }
  }

  Future<void> _importFromFile() async {
    try {
      // Pick a text file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not read file path')),
          );
        }
        return;
      }

      // Read the file line by line
      final file = File(filePath);
      final lines = await file.readAsLines();

      // Filter out empty lines and import
      final vegetables = lines
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (vegetables.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No vegetables found in file')),
          );
        }
        return;
      }

      // Import vegetables
      final importedCount = await _service.importVegetables(vegetables);

      // Reload the list
      await _loadVegetables();

      // Show feedback
      if (mounted) {
        final totalInFile = vegetables.length;
        final skippedCount = totalInFile - importedCount;
        final message = importedCount == 0
            ? 'No new vegetables to import (all duplicates)'
            : skippedCount == 0
            ? 'Imported $importedCount vegetables'
            : 'Imported $importedCount vegetables ($skippedCount duplicates skipped)';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: importedCount > 0 ? Colors.green : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error importing file: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetables'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _importFromFile,
            tooltip: 'Import from file',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vegetables.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No vegetables yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a vegetable',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _vegetables.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.eco,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(_vegetables[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(index),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _showDeleteDialog(index),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add Vegetable',
        child: const Icon(Icons.add),
      ),
    );
  }
}
