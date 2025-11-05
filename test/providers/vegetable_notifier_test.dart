import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_vegetables_firestore/ui/vegetable_list/models/vegetable.dart';
import 'package:load_vegetables_firestore/ui/vegetable_list/providers/vegetable_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper to create mock vegetables JSON for testing
String createMockVegetablesJson(List<String> names) {
  final vegetables = names
      .map((name) => Vegetable(name: name))
      .map((v) => v.toMap())
      .toList();
  return jsonEncode(vegetables);
}

void main() {
  group('VegetablesNotifier', () {
    late ProviderContainer container;

    setUp(() {
      // Initialize with empty data for each test
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial load returns empty list when no data exists', () async {
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, isEmpty);
    });

    test('initial load returns stored vegetables', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato', 'Broccoli']),
      });

      container = ProviderContainer();
      final vegetables = await container.read(vegetablesProvider.future);

      expect(vegetables, hasLength(3));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
    });

    test('add() adds a new vegetable to the list', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add(Vegetable(name: 'Tomato'));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(1));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
    });

    test('add() with empty string does not add vegetable', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add(Vegetable(name: ''));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, isEmpty);
    });

    test('add() with whitespace-only string does not add vegetable', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add(Vegetable(name: '   '));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, isEmpty);
    });

    test('add() adds multiple vegetables', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add(Vegetable(name: 'Carrot'));
      await container.read(vegetablesProvider.notifier).add(Vegetable(name: 'Tomato'));
      await container.read(vegetablesProvider.notifier).add(Vegetable(name: 'Broccoli'));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(3));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
    });

    test('updateVegetable() updates vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato', 'Broccoli']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(1, Vegetable(name: 'Cucumber'));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(3));
      expect(vegetables[0].name, 'Carrot');
      expect(vegetables[1].name, 'Cucumber');
      expect(vegetables[2].name, 'Broccoli');
    });

    test('updateVegetable() with empty string does not update', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(1, Vegetable(name: ''));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables[1].name, 'Tomato');
    });

    test('updateVegetable() handles invalid index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(5, Vegetable(name: 'Cucumber'));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
    });

    test('updateVegetable() handles negative index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(-1, Vegetable(name: 'Cucumber'));

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
    });

    test('delete() removes vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato', 'Broccoli']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(1);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
      expect(vegetables.map((v) => v.name), isNot(contains('Tomato')));
    });

    test('delete() handles invalid index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(5);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
    });

    test('delete() handles negative index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(-1);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
    });

    test('import() adds new vegetables', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      final count = await container.read(vegetablesProvider.notifier).import([
        'Tomato',
        'Broccoli',
        'Cucumber',
      ]);

      expect(count, 3);
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(4));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
      expect(vegetables.map((v) => v.name), contains('Cucumber'));
    });

    test('import() skips duplicates (case-insensitive)', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      final count = await container.read(vegetablesProvider.notifier).import([
        'carrot', // Duplicate (different case)
        'TOMATO', // Duplicate (different case)
        'Broccoli', // New
        'Cucumber', // New
      ]);

      expect(count, 2); // Only 2 new vegetables added
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(4));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
      expect(vegetables.map((v) => v.name), contains('Cucumber'));
    });

    test('import() skips empty lines', () async {
      await container.read(vegetablesProvider.future);

      final count = await container.read(vegetablesProvider.notifier).import([
        'Carrot',
        '',
        '   ',
        'Tomato',
      ]);

      expect(count, 2);
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
    });

    test('import() trims whitespace', () async {
      await container.read(vegetablesProvider.future);

      final count = await container.read(vegetablesProvider.notifier).import([
        '  Carrot  ',
        'Tomato   ',
        '  Broccoli',
      ]);

      expect(count, 3);
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables.map((v) => v.name), contains('Carrot'));
      expect(vegetables.map((v) => v.name), contains('Tomato'));
      expect(vegetables.map((v) => v.name), contains('Broccoli'));
    });

    test('import() returns 0 when all are duplicates', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      final count = await container
          .read(vegetablesProvider.notifier)
          .import(['Carrot', 'Tomato']);

      expect(count, 0);
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
    });

    test('import() to empty list', () async {
      await container.read(vegetablesProvider.future);

      final count = await container.read(vegetablesProvider.notifier).import([
        'Carrot',
        'Tomato',
        'Broccoli',
      ]);

      expect(count, 3);
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(3));
    });

    test('refresh() reloads vegetables from storage', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      container = ProviderContainer();
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));

      // Manually update SharedPreferences to simulate external change
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vegetables', createMockVegetablesJson(['Cucumber', 'Broccoli', 'Spinach']));

      // Refresh should reload from storage
      await container.read(vegetablesProvider.notifier).refresh();

      final refreshedVegetables = await container.read(vegetablesProvider.future);
      expect(refreshedVegetables, hasLength(3));
      expect(refreshedVegetables.map((v) => v.name), contains('Cucumber'));
      expect(refreshedVegetables.map((v) => v.name), contains('Broccoli'));
      expect(refreshedVegetables.map((v) => v.name), contains('Spinach'));
    });
  });
}
