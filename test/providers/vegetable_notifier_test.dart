import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_vegetables_firestore/ui/vegetable_list/providers/vegetable_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      container = ProviderContainer();
      final vegetables = await container.read(vegetablesProvider.future);

      expect(vegetables, hasLength(3));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
    });

    test('add() adds a new vegetable to the list', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add('Tomato');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(1));
      expect(vegetables, contains('Tomato'));
    });

    test('add() with empty string does not add vegetable', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add('');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, isEmpty);
    });

    test('add() with whitespace-only string does not add vegetable', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add('   ');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, isEmpty);
    });

    test('add() adds multiple vegetables', () async {
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).add('Carrot');
      await container.read(vegetablesProvider.notifier).add('Tomato');
      await container.read(vegetablesProvider.notifier).add('Broccoli');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(3));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
    });

    test('updateVegetable() updates vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(1, 'Cucumber');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(3));
      expect(vegetables[0], 'Carrot');
      expect(vegetables[1], 'Cucumber');
      expect(vegetables[2], 'Broccoli');
    });

    test('updateVegetable() with empty string does not update', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(1, '');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables[1], 'Tomato');
    });

    test('updateVegetable() handles invalid index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(5, 'Cucumber');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('updateVegetable() handles negative index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).updateVegetable(-1, 'Cucumber');

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('delete() removes vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(1);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, isNot(contains('Tomato')));
    });

    test('delete() handles invalid index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(5);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
    });

    test('delete() handles negative index gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      await container.read(vegetablesProvider.future);

      await container.read(vegetablesProvider.notifier).delete(-1);

      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));
    });

    test('import() adds new vegetables', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
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
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, contains('Cucumber'));
    });

    test('import() skips duplicates (case-insensitive)', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
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
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, contains('Cucumber'));
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
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
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
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
    });

    test('import() returns 0 when all are duplicates', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
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
        'vegetables': ['Carrot', 'Tomato'],
      });

      container = ProviderContainer();
      final vegetables = await container.read(vegetablesProvider.future);
      expect(vegetables, hasLength(2));

      // Manually update SharedPreferences to simulate external change
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('vegetables', ['Cucumber', 'Broccoli', 'Spinach']);

      // Refresh should reload from storage
      await container.read(vegetablesProvider.notifier).refresh();

      final refreshedVegetables = await container.read(vegetablesProvider.future);
      expect(refreshedVegetables, hasLength(3));
      expect(refreshedVegetables, contains('Cucumber'));
      expect(refreshedVegetables, contains('Broccoli'));
      expect(refreshedVegetables, contains('Spinach'));
    });
  });
}
