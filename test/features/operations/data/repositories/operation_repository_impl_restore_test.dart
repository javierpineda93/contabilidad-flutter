import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:contabilidad_flutter/core/database/database_helper.dart';
import 'package:contabilidad_flutter/features/operations/data/datasources/local/operations_local_datasource_impl.dart';
import 'package:contabilidad_flutter/features/operations/data/repositories/operation_repository_impl.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';
import 'package:contabilidad_flutter/features/operations/domain/usecases/restore_operations.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late OperationRepositoryImpl repository;
  late RestoreOperations restore;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseHelper = DatabaseHelper.forTesting();

    final dataSource = OperationsLocalDataSourceImpl(
      databaseHelper,
    );

    repository = OperationRepositoryImpl(
      dataSource,
    );

    restore = RestoreOperations(
      repository,
    );
  });

  tearDown(() async {
    await databaseHelper.close();
  });

  test(
    'restaura operaciones y las guarda en SQLite',
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

      final restored = await repository.getAll();

      expect(restored.length, 2);

      expect(
        restored.map((operation) => operation.concept),
        containsAll([
          'Supermercado',
          'Nómina',
        ]),
      );

      expect(
        restored.map((operation) => operation.amount),
        containsAll([
          50,
          1500,
        ]),
      );

      expect(
        restored.map((operation) => operation.type),
        containsAll([
          OperationType.expense,
          OperationType.income,
        ]),
      );
    },
  );

  test(
    'las operaciones restauradas reciben nuevos IDs',
    () async {
      final operations = [
        Operation.create(
          type: OperationType.expense,
          amount: 25,
          concept: 'Gasolina',
          date: DateTime(2026, 8, 5),
        ),
        Operation.create(
          type: OperationType.expense,
          amount: 30,
          concept: 'Restaurante',
          date: DateTime(2026, 8, 6),
        ),
      ];

      await restore(operations);

      final restored = await repository.getAll();

      expect(restored.length, 2);

      expect(restored[0].id, isNotNull);
      expect(restored[1].id, isNotNull);

      expect(
        restored[0].id,
        isNot(restored[1].id),
      );
    },
  );

  test(
    'restaurar una lista vacía no modifica SQLite',
    () async {
      await restore([]);

      final restored = await repository.getAll();

      expect(restored, isEmpty);
    },
  );
}