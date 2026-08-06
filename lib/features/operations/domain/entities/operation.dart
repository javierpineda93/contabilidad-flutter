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

    Operation touch() {
    return copyWith(
      updatedAt: DateTime.now(),
    );
  }

  factory Operation.create({
  required OperationType type,
  required double amount,
  required String concept,
  DateTime? date,
 }) {
  final now = DateTime.now();

  return Operation(
    type: type,
    amount: amount,
    concept: concept,
    date: date ?? now,
    createdAt: now,
    updatedAt: now,
  );
 }
 
}