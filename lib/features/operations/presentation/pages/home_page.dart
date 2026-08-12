import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';
import 'add_operation_page.dart';
import 'analytics_page.dart';
import 'history_page.dart';
import '../providers/editing_operation_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final editingOperation = ref.watch(editingOperationProvider);
    const pages = [
      AddOperationPage(),
      HistoryPage(),
      AnalyticsPage(),
    ];

    const titles = [
      'Añadir operación',
      'Histórico',
      'Visualización',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentIndex == 0 && editingOperation != null
              ? 'Editar operación'
              : titles[currentIndex],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Añadir',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Visualización',
          ),
        ],
      ),
    );
  }
}