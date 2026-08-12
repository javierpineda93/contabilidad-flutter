import 'package:flutter_test/flutter_test.dart';

import 'package:contabilidad_flutter/features/operations/data/models/operations_backup_model.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';

void main() {
  group('OperationsBackupModel', () {
    test('crea un backup válido desde una lista de operaciones', () {
      final operation = OperationBackupItem(
        type: OperationType.expense,
        amount: 25.50,
        concept: 'Supermercado',
        date: DateTime(2026, 8, 12),
        createdAt: DateTime(2026, 8, 12, 10),
        updatedAt: DateTime(2026, 8, 12, 10),
      );

      final backup = OperationsBackupModel(
        version: 1,
        createdAt: DateTime(2026, 8, 12),
        operations: [operation],
      );

      expect(backup.version, 1);
      expect(backup.operations.length, 1);
      expect(
        backup.operations.first.concept,
        'Supermercado',
      );
    });

    test('convierte correctamente a JSON y vuelve a modelo', () {
      final backup = OperationsBackupModel(
        version: 1,
        createdAt: DateTime(2026, 8, 12),
        operations: [
          OperationBackupItem(
            type: OperationType.income,
            amount: 1500,
            concept: 'Nómina',
            date: DateTime(2026, 8, 1),
            createdAt: DateTime(2026, 8, 1, 9),
            updatedAt: DateTime(2026, 8, 1, 9),
          ),
        ],
      );

      final json = backup.toJson();
      final restored = OperationsBackupModel.fromJson(json);

      expect(restored.version, 1);
      expect(restored.operations.length, 1);

      final operation = restored.operations.first;

      expect(operation.type, OperationType.income);
      expect(operation.amount, 1500);
      expect(operation.concept, 'Nómina');
      expect(
        operation.date,
        DateTime(2026, 8, 1),
      );
    });

    test('rechaza una versión de backup no soportada', () {
      expect(
        () => OperationsBackupModel.fromJson({
          'version': 99,
          'createdAt': '2026-08-12T10:00:00.000',
          'operations': [],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza un backup sin lista de operaciones', () {
      expect(
        () => OperationsBackupModel.fromJson({
          'version': 1,
          'createdAt': '2026-08-12T10:00:00.000',
          'operations': 'incorrecto',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza una operación con importe inválido', () {
      expect(
        () => OperationsBackupModel.fromJson({
          'version': 1,
          'createdAt': '2026-08-12T10:00:00.000',
          'operations': [
            {
              'type': 'Gasto',
              'amount': 'incorrecto',
              'concept': 'Prueba',
              'date': '2026-08-12T10:00:00.000',
              'createdAt': '2026-08-12T10:00:00.000',
              'updatedAt': '2026-08-12T10:00:00.000',
            },
          ],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza un tipo de operación inválido', () {
      expect(
        () => OperationsBackupModel.fromJson({
          'version': 1,
          'createdAt': '2026-08-12T10:00:00.000',
          'operations': [
            {
              'type': 'Transferencia',
              'amount': 100,
              'concept': 'Prueba',
              'date': '2026-08-12T10:00:00.000',
              'createdAt': '2026-08-12T10:00:00.000',
              'updatedAt': '2026-08-12T10:00:00.000',
            },
          ],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza un concepto vacío', () {
      expect(
        () => OperationsBackupModel.fromJson({
          'version': 1,
          'createdAt': '2026-08-12T10:00:00.000',
          'operations': [
            {
              'type': 'Gasto',
              'amount': 100,
              'concept': '   ',
              'date': '2026-08-12T10:00:00.000',
              'createdAt': '2026-08-12T10:00:00.000',
              'updatedAt': '2026-08-12T10:00:00.000',
            },
          ],
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}