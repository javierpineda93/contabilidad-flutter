import 'package:flutter_test/flutter_test.dart';

import 'package:contabilidad_flutter/features/operations/domain/entities/operation.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';

void main() {
  group('Operation', () {
    test('crea correctamente una operación de gasto', () {
      final operation = Operation.create(
        type: OperationType.expense,
        amount: 25.50,
        concept: 'Supermercado',
        date: DateTime(2026, 8, 11),
      );

      expect(operation.type, OperationType.expense);
      expect(operation.amount, 25.50);
      expect(operation.concept, 'Supermercado');
      expect(operation.date, DateTime(2026, 8, 11));
    });

    test('crea correctamente una operación de ingreso', () {
      final operation = Operation.create(
        type: OperationType.income,
        amount: 1500,
        concept: 'Nómina',
        date: DateTime(2026, 8, 11),
      );

      expect(operation.type, OperationType.income);
      expect(operation.amount, 1500);
      expect(operation.concept, 'Nómina');
    });

    test('una operación nueva no tiene id', () {
      final operation = Operation.create(
        type: OperationType.expense,
        amount: 10,
        concept: 'Café',
        date: DateTime(2026, 8, 11),
      );

      expect(operation.id, isNull);
    });
  });
}