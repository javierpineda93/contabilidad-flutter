import '../entities/operation.dart';
import '../repositories/operation_repository.dart';

class RestoreOperations {
  RestoreOperations(this._repository);

  final OperationRepository _repository;

  Future<void> call(List<Operation> operations) {
    return _repository.replaceAll(operations);
  }
}