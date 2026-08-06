import '../entities/operation.dart';
import '../repositories/operation_repository.dart';
import 'base/use_case.dart';

class GetOperationById
    implements UseCase<Operation?, GetOperationByIdParams> {
  GetOperationById(this._repository);

  final OperationRepository _repository;

  @override
  Future<Operation?> call(GetOperationByIdParams params) {
    return _repository.getById(params.id);
  }
}

class GetOperationByIdParams {
  const GetOperationByIdParams({
    required this.id,
  });

  final int id;
}