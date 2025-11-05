import 'package:flutter_test/flutter_test.dart';
import 'package:load_vegetables_firestore/ui/vegetable_list/view_model/vegetable_list_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('VegetableService', () {
    late VegetableService service;

    setUp(() {
      service = VegetableService();
    });

    tearDown(() async {
      // Clean up shared preferences after each test
      SharedPreferences.setMockInitialValues({});
    });

    test('loadVegetables returns empty list when no data exists', () async {
      SharedPreferences.setMockInitialValues({});

      final vegetables = await service.loadVegetables();

      expect(vegetables, isEmpty);
    });

    test('loadVegetables returns stored vegetables', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      final vegetables = await service.loadVegetables();

      expect(vegetables, hasLength(3));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
    });

    test('saveVegetables persists vegetables to storage', () async {
      SharedPreferences.setMockInitialValues({});

      await service.saveVegetables(['Cucumber', 'Pepper']);

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Cucumber'));
      expect(vegetables, contains('Pepper'));
    });

    test('addVegetable adds a new vegetable to the list', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await service.addVegetable('Tomato');

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('addVegetable to empty list', () async {
      SharedPreferences.setMockInitialValues({});

      await service.addVegetable('Carrot');

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(1));
      expect(vegetables, contains('Carrot'));
    });

    test('updateVegetable updates vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      await service.updateVegetable(1, 'Cucumber');

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(3));
      expect(vegetables[0], 'Carrot');
      expect(vegetables[1], 'Cucumber');
      expect(vegetables[2], 'Broccoli');
    });

    test('updateVegetable handles invalid index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      await service.updateVegetable(5, 'Cucumber');

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('updateVegetable handles negative index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      await service.updateVegetable(-1, 'Cucumber');

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('deleteVegetable removes vegetable at index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      await service.deleteVegetable(1);

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, isNot(contains('Tomato')));
    });

    test('deleteVegetable handles invalid index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      await service.deleteVegetable(5);

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
    });

    test('deleteVegetable handles negative index', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      await service.deleteVegetable(-1);

      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
    });

    test('importVegetables adds new vegetables', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      final count = await service.importVegetables([
        'Tomato',
        'Broccoli',
        'Cucumber',
      ]);

      expect(count, 3);
      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(4));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, contains('Cucumber'));
    });

    test('importVegetables skips duplicates (case-insensitive)', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      final count = await service.importVegetables([
        'carrot', // Duplicate (different case)
        'TOMATO', // Duplicate (different case)
        'Broccoli', // New
        'Cucumber', // New
      ]);

      expect(count, 2); // Only 2 new vegetables added
      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(4));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
      expect(vegetables, contains('Cucumber'));
    });

    test('importVegetables skips empty lines', () async {
      SharedPreferences.setMockInitialValues({});

      final count = await service.importVegetables([
        'Carrot',
        '',
        '   ',
        'Tomato',
      ]);

      expect(count, 2);
      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
    });

    test('importVegetables trims whitespace', () async {
      SharedPreferences.setMockInitialValues({});

      final count = await service.importVegetables([
        '  Carrot  ',
        'Tomato   ',
        '  Broccoli',
      ]);

      expect(count, 3);
      final vegetables = await service.loadVegetables();
      expect(vegetables, contains('Carrot'));
      expect(vegetables, contains('Tomato'));
      expect(vegetables, contains('Broccoli'));
    });

    test('importVegetables returns 0 when all are duplicates', () async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      final count = await service.importVegetables(['Carrot', 'Tomato']);

      expect(count, 0);
      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(2));
    });

    test('importVegetables to empty list', () async {
      SharedPreferences.setMockInitialValues({});

      final count = await service.importVegetables([
        'Carrot',
        'Tomato',
        'Broccoli',
      ]);

      expect(count, 3);
      final vegetables = await service.loadVegetables();
      expect(vegetables, hasLength(3));
    });
  });
}
