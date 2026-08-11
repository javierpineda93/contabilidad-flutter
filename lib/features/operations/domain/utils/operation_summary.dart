import '../entities/operation.dart';
import '../entities/operation_type.dart';

class OperationSummary {
  const OperationSummary({
    required this.income,
    required this.expenses,
  });

  final double income;
  final double expenses;

  double get balance => income - expenses;

  factory OperationSummary.fromOperations(
    List<Operation> operations,
  ) {
    double income = 0;
    double expenses = 0;

    for (final operation in operations) {
      if (operation.type == OperationType.income) {
        income += operation.amount;
      } else {
        expenses += operation.amount;
      }
    }

    return OperationSummary(
      income: income,
      expenses: expenses,
    );
  }
}