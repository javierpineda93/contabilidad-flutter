import '../repositories/operation_repository.dart';
import 'base/use_case.dart';

class DeleteOperation implements UseCase<void, int> {
  DeleteOperation(this._repository);

  final OperationRepository _repository;

  @override
  Future<void> call(int id) {
    return _repository.delete(id);
  }
}