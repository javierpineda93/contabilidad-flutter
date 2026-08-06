import 'operation_type.dart';

class Operation {
  const Operation({
    this.id,
    required this.type,
    required this.amount,
    required this.concept,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;

  final OperationType type;

  final double amount;

  final String concept;

  final DateTime date;

  final DateTime createdAt;

  final DateTime updatedAt;

  Operation copyWith({
    int? id,
    OperationType? type,
    double? amount,
    String? concept,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Operation(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      concept: concept ?? this.concept,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}