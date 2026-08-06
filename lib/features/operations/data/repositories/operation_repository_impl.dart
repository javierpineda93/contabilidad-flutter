import '../datasources/local/operations_local_datasource.dart';
import '../models/operation_model.dart';
import '../../domain/entities/operation.dart';
import '../../domain/repositories/operation_repository.dart';

class OperationRepositoryImpl implements OperationRepository {
  OperationRepositoryImpl(this._localDataSource);

  final OperationsLocalDataSource _localDataSource;

  @override
  Future<void> add(Operation operation) async {
    await _localDataSource.insert(
      OperationModel.fromEntity(operation),
    );
  }

  @override
  Future<void> delete(int id) {
    return _localDataSource.delete(id);
  }

  @override
  Future<List<Operation>> getAll() {
    return _localDataSource.getAll();
  }

  @override
  Future<Operation?> getById(int id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<void> update(Operation operation) {
    return _localDataSource.update(
      OperationModel.fromEntity(operation),
    );
  }
}