import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:contabilidad_flutter/core/database/database_helper.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseHelper = DatabaseHelper.forTesting();
  });

  tearDown(() async {
    await databaseHelper.close();
  });

  test(
    'una transacción hace rollback si una operación falla',
    () async {
      final db = await databaseHelper.database;

      expect(
        () async {
          await db.transaction((transaction) async {
            await transaction.insert(
              'operations',
              {
                'type': 'expense',
                'amount': 50.0,
                'concept': 'Operación válida',
                'date': '2026-08-10T10:00:00.000',
                'created_at': '2026-08-10T10:00:00.000',
                'updated_at': '2026-08-10T10:00:00.000',
              },
            );

            await transaction.insert(
              'operations',
              {
                'type': 'expense',
                'amount': null,
                'concept': 'Operación inválida',
                'date': '2026-08-10T10:00:00.000',
                'created_at': '2026-08-10T10:00:00.000',
                'updated_at': '2026-08-10T10:00:00.000',
              },
            );
          });
        },
        throwsA(isA<DatabaseException>()),
      );

      final operations = await db.query(
        'operations',
      );

      expect(
        operations,
        isEmpty,
      );
    },
  );
}