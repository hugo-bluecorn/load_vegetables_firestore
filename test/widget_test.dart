import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_vegetables_firestore/main.dart';
import 'package:load_vegetables_firestore/ui/vegetable_list/models/vegetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper to create mock vegetables JSON for testing
String createMockVegetablesJson(List<String> names, {HarvestState harvestState = HarvestState.plenty}) {
  final vegetables = names
      .map((name) => Vegetable(name: name, harvestState: harvestState))
      .map((v) => v.toMap())
      .toList();
  return jsonEncode(vegetables);
}

void main() {
  group('VegetablesListScreen Widget Tests', () {
    setUp(() {
      // Initialize with empty data for each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App title is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Title now includes the current harvest state filter (default: Plenty)
      expect(find.text('Vegetables - Plenty'), findsOneWidget);
    });

    testWidgets('Empty state is shown when no vegetables exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('No vegetables yet'), findsOneWidget);
      expect(find.text('Use the menu to add vegetables'), findsOneWidget);
      expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
    });

    testWidgets('Menu button is present in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('Displays vegetables when data exists',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato', 'Broccoli']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('Tomato'), findsOneWidget);
      expect(find.text('Broccoli'), findsOneWidget);
      expect(find.text('No vegetables yet'), findsNothing);
    });

    testWidgets('Each vegetable is dismissible',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.byType(Dismissible), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);
    });

    testWidgets('Tapping menu button shows add and import options',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Find the menu icon within the AppBar and tap it
      final menuIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.more_vert),
      );
      await tester.tap(menuIcon);
      await tester.pump(); // Start the menu animation
      await tester.pump(const Duration(seconds: 1)); // Wait for animation to complete

      expect(find.text('Add vegetable'), findsOneWidget);
      expect(find.text('Import from file'), findsOneWidget);
    });

    testWidgets('Can add a vegetable through menu and dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Open menu
      final menuIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.more_vert),
      );
      await tester.tap(menuIcon);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Tap "Add vegetable" menu item
      await tester.tap(find.text('Add vegetable'));
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

      // Open menu
      final menuIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.more_vert),
      );
      await tester.tap(menuIcon);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Tap "Add vegetable" menu item
      await tester.tap(find.text('Add vegetable'));
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

    testWidgets('Long pressing vegetable enters selection mode',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Long press on vegetable
      await tester.longPress(find.text('Carrot'));
      await tester.pumpAndSettle();

      // Should enter selection mode with "1 selected" in title
      expect(find.text('1 selected'), findsOneWidget);
      // Should show edit, delete, and move icons
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byIcon(Icons.drive_file_move), findsOneWidget);
    });

    testWidgets('Can edit a vegetable in selection mode', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Long press on vegetable to enter selection mode
      await tester.longPress(find.text('Carrot'));
      await tester.pumpAndSettle();

      // Tap edit icon
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Should show edit dialog
      expect(find.text('Edit Vegetable'), findsOneWidget);

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

    testWidgets('Swiping to dismiss shows confirmation dialog',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Swipe to dismiss
      await tester.drag(find.text('Carrot'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Delete Vegetable'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Carrot"?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsWidgets);
    });

    testWidgets('Can delete a vegetable by swiping', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(['Carrot', 'Tomato']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Swipe to dismiss Carrot
      await tester.drag(find.text('Carrot'), const Offset(-500, 0));
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
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Swipe to dismiss
      await tester.drag(find.text('Carrot'), const Offset(-500, 0));
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
        'vegetables': createMockVegetablesJson([
          'Carrot',
          'Tomato',
          'Broccoli',
          'Spinach',
          'Potato',
          'Cucumber',
        ]),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('Tomato'), findsOneWidget);
      expect(find.text('Broccoli'), findsOneWidget);
      expect(find.text('Spinach'), findsOneWidget);
      expect(find.text('Potato'), findsOneWidget);
      expect(find.text('Cucumber'), findsOneWidget);

      // Should have 6 dismissible widgets
      expect(find.byType(Dismissible), findsNWidgets(6));
    });

    testWidgets('ListView scrolls correctly with many items',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vegetables': createMockVegetablesJson(
          List.generate(20, (index) => 'Vegetable $index'),
        ),
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

      // Open menu
      final menuIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.more_vert),
      );
      await tester.tap(menuIcon);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Tap "Add vegetable" menu item
      await tester.tap(find.text('Add vegetable'));
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
        'vegetables': createMockVegetablesJson(['Carrot']),
      });

      await tester.pumpWidget(const ProviderScope(child: MainApp()));
      await tester.pumpAndSettle();

      // Should have eco icon for the vegetable item
      // Note: Multiple eco icons may exist (navigation bar + list items)
      expect(find.byIcon(Icons.eco), findsWidgets);
    });
  });
}
