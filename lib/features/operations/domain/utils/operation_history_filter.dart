import '../entities/operation.dart';
import '../entities/operation_type.dart';

enum HistoryFilter {
  all,
  income,
  expense,
}

class OperationHistoryFilter {
  const OperationHistoryFilter();

  List<Operation> filter({
    required List<Operation> operations,
    required HistoryFilter type,
    String search = '',
  }) {
    final searchText = search.trim().toLowerCase();

    return operations.where((operation) {
      final concept = operation.concept.toLowerCase();

      final typeSearchText =
          operation.type == OperationType.income
              ? 'ingreso ingresos income'
              : 'gasto gastos expense';

      final matchesSearch =
          searchText.isEmpty ||
          concept.contains(searchText) ||
          typeSearchText.contains(searchText);

      final matchesType = switch (type) {
        HistoryFilter.all => true,
        HistoryFilter.income =>
          operation.type == OperationType.income,
        HistoryFilter.expense =>
          operation.type == OperationType.expense,
      };

      return matchesSearch && matchesType;
    }).toList();
  }
}