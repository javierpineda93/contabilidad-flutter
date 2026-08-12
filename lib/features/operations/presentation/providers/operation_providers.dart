import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_helper.dart';

import '../../data/datasources/local/operations_local_datasource.dart';
import '../../data/datasources/local/operations_local_datasource_impl.dart';

import '../../data/repositories/operation_repository_impl.dart';

import '../../domain/repositories/operation_repository.dart';

import '../../domain/usecases/add_operation.dart';
import '../../domain/usecases/delete_operation.dart';
import '../../domain/usecases/get_operation_by_id.dart';
import '../../domain/usecases/get_operations.dart';
import '../../domain/usecases/operation_use_cases.dart';
import '../../domain/usecases/update_operation.dart';
import '../../domain/entities/operation.dart';
import '../../domain/usecases/base/no_params.dart';
import '../../domain/usecases/restore_operations.dart';
import '../../services/operations_backup_services.dart';

final databaseHelperProvider =
    Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final operationsLocalDataSourceProvider =
    Provider<OperationsLocalDataSource>((ref) {
  return OperationsLocalDataSourceImpl(
    ref.watch(databaseHelperProvider),
  );
});

final operationRepositoryProvider =
    Provider<OperationRepository>((ref) {
  return OperationRepositoryImpl(
    ref.watch(operationsLocalDataSourceProvider),
  );
});

final operationUseCasesProvider =
    Provider<OperationUseCases>((ref) {
  final repository =
      ref.watch(operationRepositoryProvider);

  return OperationUseCases(
  add: AddOperation(repository),
  update: UpdateOperation(repository),
  delete: DeleteOperation(repository),
  getAll: GetOperations(repository),
  getById: GetOperationById(repository),
  restore: RestoreOperations(repository),
  );
});

final operationsProvider =
    FutureProvider<List<Operation>>((ref) async {
  final useCases = ref.watch(operationUseCasesProvider);

  return useCases.getAll(
    const NoParams(),
  );
});

final operationsBackupServiceProvider =
    Provider<OperationsBackupService>((ref) {
  return OperationsBackupService();
});