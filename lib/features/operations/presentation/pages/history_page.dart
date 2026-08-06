import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/operation_providers.dart';
import '../widgets/operation_card.dart';
import '../providers/search_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(operationsProvider);
    final search = ref.watch(searchProvider);
    return operations.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      data: (list) {
      final filteredList = list.where((operation) {
        return operation.concept
            .toLowerCase()
            .contains(search.toLowerCase());
      }).toList();

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por concepto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text('No se encontraron operaciones'),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(operationsProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final operation = filteredList[index];

                        return OperationCard(
                          operation: operation,
                        );
                      },
                    ),
                  ),
          ),
        ],
      );
    },
    );
  }
}
