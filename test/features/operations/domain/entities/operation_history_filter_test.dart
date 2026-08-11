import 'package:flutter_test/flutter_test.dart';

import 'package:contabilidad_flutter/features/operations/domain/entities/operation.dart';
import 'package:contabilidad_flutter/features/operations/domain/entities/operation_type.dart';
import 'package:contabilidad_flutter/features/operations/domain/utils/operation_history_filter.dart';

void main() {
  final operations = [
    Operation.create(
      type: OperationType.income,
      amount: 2000,
      concept: 'Nómina',
      date: DateTime(2026, 8, 1),
    ),
    Operation.create(
      type: OperationType.expense,
      amount: 50,
      concept: 'Supermercado',
      date: DateTime(2026, 8, 2),
    ),
    Operation.create(
      type: OperationType.expense,
      amount: 30,
      concept: 'Gasolina',
      date: DateTime(2026, 8, 3),
    ),
  ];

  const filter = OperationHistoryFilter();

  test('el filtro Todas devuelve todas las operaciones', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.all,
    );

    expect(result.length, 3);
  });

  test('el filtro Ingresos devuelve solo ingresos', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.income,
    );

    expect(result.length, 1);
    expect(result.first.concept, 'Nómina');
  });

  test('el filtro Gastos devuelve solo gastos', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.expense,
    );

    expect(result.length, 2);
  });

  test('busca por concepto', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.all,
      search: 'gasolina',
    );

    expect(result.length, 1);
    expect(result.first.concept, 'Gasolina');
  });

  test('busca por tipo gasto', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.all,
      search: 'gasto',
    );

    expect(result.length, 2);
  });

  test('combina búsqueda y filtro de tipo', () {
    final result = filter.filter(
      operations: operations,
      type: HistoryFilter.expense,
      search: 'gasolina',
    );

    expect(result.length, 1);
    expect(result.first.concept, 'Gasolina');
  });
}