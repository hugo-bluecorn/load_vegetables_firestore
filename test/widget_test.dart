import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_vegetables_firestore/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('VegetablesListScreen Widget Tests', () {
    setUp(() {
      // Initialize with empty data for each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App title is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('Vegetables'), findsOneWidget);
    });

    testWidgets('Empty state is shown when no vegetables exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('No vegetables yet'), findsOneWidget);
      expect(find.text('Tap + to add a vegetable'), findsOneWidget);
      expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
    });

    testWidgets('Floating action button is present',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Import button is present in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.upload_file), findsOneWidget);
    });

    testWidgets('Displays vegetables when data exists',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato', 'Broccoli'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('Tomato'), findsOneWidget);
      expect(find.text('Broccoli'), findsOneWidget);
      expect(find.text('No vegetables yet'), findsNothing);
    });

    testWidgets('Each vegetable has edit and delete buttons',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('Tapping FAB shows add vegetable dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Vegetable'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Can add a vegetable through dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Open add dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter vegetable name
      await tester.enterText(find.byType(TextField), 'Cucumber');
      await tester.pumpAndSettle();

      // Tap Add button
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify vegetable was added
      expect(find.text('Cucumber'), findsOneWidget);
      expect(find.text('No vegetables yet'), findsNothing);
    });

    testWidgets('Cancel button closes add dialog without adding',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Open add dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'Cucumber');
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify vegetable was not added
      expect(find.text('Cucumber'), findsNothing);
      expect(find.text('No vegetables yet'), findsOneWidget);
    });

    testWidgets('Tapping edit button shows edit dialog',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Tap edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Vegetable'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Can edit a vegetable', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Tap edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Clear and enter new text
      await tester.enterText(find.byType(TextField), 'Cucumber');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify vegetable was updated
      expect(find.text('Cucumber'), findsOneWidget);
      expect(find.text('Carrot'), findsNothing);
    });

    testWidgets('Tapping delete button shows confirmation dialog',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Vegetable'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Carrot"?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsWidgets);
    });

    testWidgets('Can delete a vegetable', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot', 'Tomato'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Find the delete button for Carrot
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      // Verify vegetable was deleted
      expect(find.text('Carrot'), findsNothing);
      expect(find.text('Tomato'), findsOneWidget);
    });

    testWidgets('Cancel button in delete dialog preserves vegetable',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify vegetable still exists
      expect(find.text('Carrot'), findsOneWidget);
    });

    testWidgets('Displays multiple vegetables correctly',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': [
          'Carrot',
          'Tomato',
          'Broccoli',
          'Spinach',
          'Potato',
          'Cucumber',
        ],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('Tomato'), findsOneWidget);
      expect(find.text('Broccoli'), findsOneWidget);
      expect(find.text('Spinach'), findsOneWidget);
      expect(find.text('Potato'), findsOneWidget);
      expect(find.text('Cucumber'), findsOneWidget);

      // Should have 6 edit buttons and 6 delete buttons
      expect(find.byIcon(Icons.edit), findsNWidgets(6));
      expect(find.byIcon(Icons.delete), findsNWidgets(6));
    });

    testWidgets('ListView scrolls correctly with many items',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': List.generate(20, (index) => 'Vegetable $index'),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // First item should be visible
      expect(find.text('Vegetable 0'), findsOneWidget);

      // Last item might not be visible yet
      expect(find.text('Vegetable 19'), findsNothing);

      // Scroll to the bottom
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Last item should now be visible
      expect(find.text('Vegetable 19'), findsOneWidget);
    });

    testWidgets('Empty text in add dialog does not add vegetable',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Open add dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Don't enter any text, just tap Add
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Dialog should still be open (Add button does nothing with empty text)
      expect(find.text('Add Vegetable'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify no vegetables were added - empty state should still be visible
      expect(find.text('No vegetables yet'), findsOneWidget);
    });

    testWidgets('Vegetables display with eco icon', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': ['Carrot'],
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Should have eco icon for the vegetable item
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });
  });
}
