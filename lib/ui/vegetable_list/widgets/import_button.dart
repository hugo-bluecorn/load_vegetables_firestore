import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../view_model/vegetable_list_view_model.dart';

class ImportButton extends StatelessWidget {
  final VegetableService service;
  final VoidCallback onImportComplete;

  const ImportButton({
    super.key,
    required this.service,
    required this.onImportComplete,
  });

  Future<void> _importFromFile(BuildContext context) async {
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
        if (context.mounted) {
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No vegetables found in file')),
          );
        }
        return;
      }

      // Import vegetables
      final importedCount = await service.importVegetables(vegetables);

      // Reload the list
      onImportComplete();

      // Show feedback
      if (context.mounted) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error importing file: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.upload_file),
      onPressed: () => _importFromFile(context),
      tooltip: 'Import from file',
    );
  }
}
