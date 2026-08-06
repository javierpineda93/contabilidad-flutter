import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/operation.dart';
import '../providers/operation_providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(operationsProvider);

    return operations.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text(error.toString()),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text(
              'Todavía no hay operaciones',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final operation = list[index];

            return _OperationTile(
              operation: operation,
            );
          },
        );
      },
    );
  }
}

class _OperationTile extends StatelessWidget {
  const _OperationTile({
    required this.operation,
  });

  final Operation operation;

  @override
  Widget build(BuildContext context) {
    final isExpense = operation.type.name == 'expense';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isExpense ? Colors.red : Colors.green,
          child: Icon(
            isExpense
                ? Icons.remove
                : Icons.add,
            color: Colors.white,
          ),
        ),
        title: Text(operation.concept),
        subtitle: Text(
          DateFormat(
            'dd/MM/yyyy',
          ).format(operation.date),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}${operation.amount.toStringAsFixed(2)} €',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}