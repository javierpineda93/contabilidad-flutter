import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:contabilidad_flutter/core/database/database_helper.dart';
import 'package:contabilidad_flutter/features/operations/data/datasources/local/operations_local_datasource_impl.dart';
import 'package:contabilidad_flutter/features/operations/data/models/operation_model.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late OperationsLocalDataSourceImpl dataSource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseHelper = DatabaseHelper.forTesting();

    dataSource = OperationsLocalDataSourceImpl(
      databaseHelper,
    );
  });

  tearDown(() async {
    await databaseHelper.close();
  });

  OperationModel createOperation({
    required String concept,
    required double amount,
  }) {
    final now = DateTime(2026, 8, 12, 10);

    return OperationModel(
      type: OperationType.expense,
      amount: amount,
      concept: concept,
      date: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  test(
    'insertAll inserta varias operaciones',
    () async {
      final operations = [
        createOperation(
          concept: 'Supermercado',
          amount: 50,
        ),
        createOperation(
          concept: 'Gasolina',
          amount: 40,
        ),
        createOperation(
          concept: 'Restaurante',
          amount: 30,
        ),
      ];

      await dataSource.insertAll(operations);

      final result = await dataSource.getAll();

      expect(result.length, 3);

      expect(
        result.map((operation) => operation.concept),
        containsAll([
          'Supermercado',
          'Gasolina',
          'Restaurante',
        ]),
      );
    },
  );

  test(
    'insertAll con lista vacía no inserta operaciones',
    () async {
      await dataSource.insertAll([]);

      final result = await dataSource.getAll();

      expect(result, isEmpty);
    },
  );

  test(
    'insertAll genera nuevos IDs automáticamente',
    () async {
      final operations = [
        createOperation(
          concept: 'Operación 1',
          amount: 100,
        ),
        createOperation(
          concept: 'Operación 2',
          amount: 200,
        ),
      ];

      await dataSource.insertAll(operations);

      final result = await dataSource.getAll();

      expect(result.length, 2);
      expect(result[0].id, isNotNull);
      expect(result[1].id, isNotNull);

      expect(
        result[0].id,
        isNot(result[1].id),
      );
    },
  );
}