import '../../domain/entities/operation.dart';
import '../../domain/entities/operation_type.dart';

class OperationsBackupModel {
  const OperationsBackupModel({
    required this.version,
    required this.createdAt,
    required this.operations,
  });

  final int version;
  final DateTime createdAt;
  final List<OperationBackupItem> operations;

  factory OperationsBackupModel.fromOperations(
    List<Operation> operations,
  ) {
    return OperationsBackupModel(
      version: 1,
      createdAt: DateTime.now(),
      operations: operations
          .map(OperationBackupItem.fromOperation)
          .toList(),
    );
  }

  factory OperationsBackupModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final version = json['version'];

    if (version != 1) {
      throw const FormatException(
        'Versión de copia de seguridad no compatible.',
      );
    }

    final createdAtValue = json['createdAt'];

    if (createdAtValue is! String) {
      throw const FormatException(
        'La fecha de creación de la copia no es válida.',
      );
    }

    final operationsValue = json['operations'];

    if (operationsValue is! List) {
      throw const FormatException(
        'La copia no contiene una lista de operaciones válida.',
      );
    }

    final operations = operationsValue.map((item) {
      if (item is! Map) {
        throw const FormatException(
          'Una operación de la copia no tiene un formato válido.',
        );
      }

      return OperationBackupItem.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();

    return OperationsBackupModel(
      version: version,
      createdAt: DateTime.parse(createdAtValue),
      operations: operations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'operations': operations
          .map((operation) => operation.toJson())
          .toList(),
    };
  }
}

class OperationBackupItem {
  const OperationBackupItem({
    required this.type,
    required this.amount,
    required this.concept,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  final OperationType type;
  final double amount;
  final String concept;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory OperationBackupItem.fromOperation(
    Operation operation,
  ) {
    return OperationBackupItem(
      type: operation.type,
      amount: operation.amount,
      concept: operation.concept,
      date: operation.date,
      createdAt: operation.createdAt,
      updatedAt: operation.updatedAt,
    );
  }

  factory OperationBackupItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeValue = json['type'];

    if (typeValue is! String) {
      throw const FormatException(
        'El tipo de operación no es válido.',
      );
    }

    final amountValue = json['amount'];

    if (amountValue is! num) {
      throw const FormatException(
        'El importe de una operación no es válido.',
      );
    }

    final conceptValue = json['concept'];

    if (conceptValue is! String ||
        conceptValue.trim().isEmpty) {
      throw const FormatException(
        'El concepto de una operación no es válido.',
      );
    }

    final dateValue = json['date'];
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];

    if (dateValue is! String ||
        createdAtValue is! String ||
        updatedAtValue is! String) {
      throw const FormatException(
        'Una de las fechas de una operación no es válida.',
      );
    }

    try {
      return OperationBackupItem(
        type: OperationType.fromString(typeValue),
        amount: amountValue.toDouble(),
        concept: conceptValue.trim(),
        date: DateTime.parse(dateValue),
        createdAt: DateTime.parse(createdAtValue),
        updatedAt: DateTime.parse(updatedAtValue),
      );
    } catch (e) {
      throw FormatException(
        'Una operación contiene datos inválidos: $e',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'amount': amount,
      'concept': concept,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Operation toOperation() {
    return Operation.create(
      type: type,
      amount: amount,
      concept: concept,
      date: date,
    ).copyWith(
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}