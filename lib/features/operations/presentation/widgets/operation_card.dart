import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/operation.dart';
import '../../domain/entities/operation_type.dart';

class OperationCard extends StatelessWidget {
  const OperationCard({
    super.key,
    required this.operation,
    this.onTap,
    this.onLongPress,
  });

  final Operation operation;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final isExpense = operation.type == OperationType.expense;

    return Card(
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundColor: isExpense ? Colors.red : Colors.green,
          child: Icon(
            isExpense ? Icons.remove : Icons.add,
            color: Colors.white,
          ),
        ),
        title: Text(
          operation.concept,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(operation.date),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}${operation.amount.toStringAsFixed(2)} €',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}