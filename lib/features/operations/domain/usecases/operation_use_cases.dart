import 'add_operation.dart';
import 'delete_operation.dart';
import 'get_operation_by_id.dart';
import 'get_operations.dart';
import 'restore_operations.dart';
import 'update_operation.dart';

class OperationUseCases {
  const OperationUseCases({
    required this.add,
    required this.update,
    required this.delete,
    required this.getAll,
    required this.getById,
    required this.restore,
  });

  final AddOperation add;
  final UpdateOperation update;
  final DeleteOperation delete;
  final GetOperations getAll;
  final GetOperationById getById;
  final RestoreOperations restore;
}