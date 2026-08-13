import 'package:flutter_test/flutter_test.dart';

import 'package:contabilidad_flutter/features/operations/domain/entities/operation.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';
import 'package:contabilidad_flutter/features/operations/domain/repositories/operation_repository.dart';
import 'package:contabilidad_flutter/features/operations/domain/usecases/restore_operations.dart';

  class FakeOperationRepository
      implements OperationRepository {
    List<Operation> restoredOperations = [];

    @override
    Future<void> add(Operation operation) async {}

    @override
    Future<void> addAll(
      List<Operation> operations,
    ) async {}

    @override
    Future<void> replaceAll(
      List<Operation> operations,
    ) async {
      restoredOperations = operations;
    }

    @override
    Future<void> update(Operation operation) async {}

    @override
    Future<void> delete(int id) async {}

    @override
    Future<List<Operation>> getAll() async {
      return [];
    }

    @override
    Future<Operation?> getById(int id) async {
      return null;
    }
  }

void main() {
  late FakeOperationRepository repository;
  late RestoreOperations restore;

  setUp(() {
    repository = FakeOperationRepository();
    restore = RestoreOperations(repository);
  });

  test(
    'restaura todas las operaciones mediante el repositorio',
    () async {
      final operations = [
        Operation.create(
          type: OperationType.expense,
          amount: 50,
          concept: 'Supermercado',
          date: DateTime(2026, 8, 10),
        ),
        Operation.create(
          type: OperationType.income,
          amount: 1500,
          concept: 'Nómina',
          date: DateTime(2026, 8, 1),
        ),
      ];

      await restore(operations);

      expect(
        repository.restoredOperations.length,
        2,
      );

      expect(
        repository.restoredOperations[0].concept,
        'Supermercado',
      );

      expect(
        repository.restoredOperations[1].concept,
        'Nómina',
      );
    },
  );

  test(
    'restaurar una lista vacía no produce operaciones',
    () async {
      await restore([]);

      expect(
        repository.restoredOperations,
        isEmpty,
      );
    },
  );
}