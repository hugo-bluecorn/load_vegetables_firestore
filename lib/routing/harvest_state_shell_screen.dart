import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell screen that wraps the navigation with a bottom NavigationBar
/// for switching between harvest state tabs
class HarvestStateShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HarvestStateShellScreen({
    required this.navigationShell,
    super.key,
  });

  Color _getIndicatorColor() {
    switch (navigationShell.currentIndex) {
      case 0: // Plenty
        return Colors.amber;
      case 1: // Enough
        return Colors.blue;
      case 2: // Scarce
        return Colors.deepPurple;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: _getIndicatorColor().withValues(alpha: 0.3),
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.park, color: Colors.amber.shade700),
            selectedIcon: Icon(Icons.park, color: Colors.amber.shade900),
            label: 'Plenty',
            tooltip: 'Plenty harvest state',
          ),
          NavigationDestination(
            icon: Icon(Icons.nature, color: Colors.blue.shade700),
            selectedIcon: Icon(Icons.nature, color: Colors.blue.shade900),
            label: 'Enough',
            tooltip: 'Enough harvest state',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco, color: Colors.deepPurple.shade700),
            selectedIcon: Icon(Icons.eco, color: Colors.deepPurple.shade900),
            label: 'Scarce',
            tooltip: 'Scarce harvest state',
          ),
        ],
      ),
    );
  }
}
