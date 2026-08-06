import '../entities/operation.dart';
import '../repositories/operation_repository.dart';
import 'base/use_case.dart';

class AddOperation implements UseCase<void, Operation> {
  AddOperation(this._repository);

  final OperationRepository _repository;

  @override
  Future<void> call(Operation operation) {
    return _repository.add(operation);
  }
}