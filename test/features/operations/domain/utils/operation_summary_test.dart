import 'package:flutter_test/flutter_test.dart';

import 'package:contabilidad_flutter/features/operations/domain/entities/operation.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';
import 'package:contabilidad_flutter/features/operations/domain/utils/operation_summary.dart';

void main() {
  group('OperationSummary', () {
    test('calcula ingresos, gastos y saldo correctamente', () {
      final operations = [
        Operation.create(
          type: OperationType.income,
          amount: 2000,
          concept: 'Nómina',
          date: DateTime(2026, 8, 1),
        ),
        Operation.create(
          type: OperationType.expense,
          amount: 500,
          concept: 'Alquiler',
          date: DateTime(2026, 8, 2),
        ),
        Operation.create(
          type: OperationType.expense,
          amount: 100,
          concept: 'Supermercado',
          date: DateTime(2026, 8, 3),
        ),
      ];

      final summary =
          OperationSummary.fromOperations(operations);

      expect(summary.income, 2000);
      expect(summary.expenses, 600);
      expect(summary.balance, 1400);
    });

    test('una lista vacía devuelve todos los valores a cero', () {
      final summary =
          OperationSummary.fromOperations([]);

      expect(summary.income, 0);
      expect(summary.expenses, 0);
      expect(summary.balance, 0);
    });

    test('calcula correctamente cuando solo hay gastos', () {
      final operations = [
        Operation.create(
          type: OperationType.expense,
          amount: 100,
          concept: 'Comida',
          date: DateTime(2026, 8, 1),
        ),
        Operation.create(
          type: OperationType.expense,
          amount: 50,
          concept: 'Transporte',
          date: DateTime(2026, 8, 2),
        ),
      ];

      final summary =
          OperationSummary.fromOperations(operations);

      expect(summary.income, 0);
      expect(summary.expenses, 150);
      expect(summary.balance, -150);
    });
  });
}