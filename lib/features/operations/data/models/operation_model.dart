import '../../domain/entities/operation.dart';
import '../../domain/entities/operation_type.dart';

class OperationModel extends Operation {
  const OperationModel({
    super.id,
    required super.type,
    required super.amount,
    required super.concept,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OperationModel.fromMap(Map<String, dynamic> map) {
    return OperationModel(
      id: map['id'] as int?,
      type: OperationType.fromString(map['type'] as String),
      amount: (map['amount'] as num).toDouble(),
      concept: map['concept'] as String,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.value,
      'amount': amount,
      'concept': concept,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory OperationModel.fromEntity(Operation operation) {
    return OperationModel(
      id: operation.id,
      type: operation.type,
      amount: operation.amount,
      concept: operation.concept,
      date: operation.date,
      createdAt: operation.createdAt,
      updatedAt: operation.updatedAt,
    );
  }
}