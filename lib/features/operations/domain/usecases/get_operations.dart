import '../entities/operation.dart';
import '../repositories/operation_repository.dart';
import 'base/no_params.dart';
import 'base/use_case.dart';

class GetOperations implements UseCase<List<Operation>, NoParams> {
  GetOperations(this._repository);

  final OperationRepository _repository;

  @override
  Future<List<Operation>> call(NoParams params) {
    return _repository.getAll();
  }
}