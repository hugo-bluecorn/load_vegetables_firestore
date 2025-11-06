import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../ui/vegetable_list/models/vegetable.dart';
import '../ui/vegetable_list/widgets/vegetable_list_screen.dart';
import 'harvest_state_shell_screen.dart';

/// Provider for the GoRouter configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/plenty',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HarvestStateShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Plenty branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/plenty',
                name: 'plenty',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: VegetablesListScreen(harvestState: HarvestState.plenty),
                ),
              ),
            ],
          ),
          // Enough branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/enough',
                name: 'enough',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: VegetablesListScreen(harvestState: HarvestState.enough),
                ),
              ),
            ],
          ),
          // Scarce branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scarce',
                name: 'scarce',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: VegetablesListScreen(harvestState: HarvestState.scarce),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
