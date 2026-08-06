import '../entities/operation.dart';

abstract interface class OperationRepository {
  Future<List<Operation>> getAll();

  Future<Operation?> getById(int id);

  Future<void> add(Operation operation);

  Future<void> update(Operation operation);

  Future<void> delete(int id);
}