enum OperationType {
  income,
  expense;

  String get value => switch (this) {
        OperationType.income => 'Ingreso',
        OperationType.expense => 'Gasto',
      };

  static OperationType fromString(String value) {
    switch (value) {
      case 'Ingreso':
        return OperationType.income;
      case 'Gasto':
        return OperationType.expense;
      default:
        throw ArgumentError('Tipo de operación inválido: $value');
    }
  }
}