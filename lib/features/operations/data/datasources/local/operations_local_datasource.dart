import '../../models/operation_model.dart';

abstract interface class OperationsLocalDataSource {
  Future<List<OperationModel>> getAll();

  Future<OperationModel?> getById(int id);

  Future<void> insert(OperationModel operation);

  Future<void> update(OperationModel operation);

  Future<void> delete(int id);
}