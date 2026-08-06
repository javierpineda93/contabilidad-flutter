import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../models/operation_model.dart';
import 'operations_local_datasource.dart';

class OperationsLocalDataSourceImpl
    implements OperationsLocalDataSource {
  OperationsLocalDataSourceImpl(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  Future<Database> get _db async => _databaseHelper.database;

  @override
  Future<void> insert(OperationModel operation) async {
    final db = await _db;

    await db.insert(
      'operations',
      operation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(OperationModel operation) async {
    final db = await _db;

    await db.update(
      'operations',
      operation.toMap(),
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await _db;

    await db.delete(
      'operations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<OperationModel>> getAll() async {
    final db = await _db;

    final result = await db.query(
      'operations',
      orderBy: 'date DESC',
    );

    return result
        .map(OperationModel.fromMap)
        .toList();
  }

  @override
  Future<OperationModel?> getById(int id) async {
    final db = await _db;

    final result = await db.query(
      'operations',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return OperationModel.fromMap(result.first);
  }
}