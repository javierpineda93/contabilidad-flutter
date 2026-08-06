import '../entities/operation.dart';
import '../repositories/operation_repository.dart';
import 'base/use_case.dart';

class UpdateOperation implements UseCase<void, Operation> {
  UpdateOperation(this._repository);

  final OperationRepository _repository;

  @override
  Future<void> call(Operation operation) {
    return _repository.update(operation);
  }
}