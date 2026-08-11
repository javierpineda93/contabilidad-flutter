import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/entities/operation.dart';
import '../../domain/entities/operation_type.dart';
import '../providers/analytics_provider.dart';
import '../providers/operation_providers.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(operationsProvider);
    final selectedPeriod = ref.watch(analyticsPeriodProvider);

    return operations.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error al cargar las estadísticas: $error',
        ),
      ),
      data: (list) {
        final filteredList = _filterOperations(
          list,
          selectedPeriod,
        );

        double income = 0;
        double expenses = 0;

        for (final operation in filteredList) {
          if (operation.type == OperationType.income) {
            income += operation.amount;
          } else {
            expenses += operation.amount;
          }
        }

        final balance = income - expenses;

        final monthlyData = _buildMonthlyData(filteredList);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<AnalyticsPeriod>(
                initialValue: selectedPeriod,
                decoration: const InputDecoration(
                  labelText: 'Periodo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: AnalyticsPeriod.currentMonth,
                    child: Text('Este mes'),
                  ),
                  DropdownMenuItem(
                    value: AnalyticsPeriod.previousMonth,
                    child: Text('Mes anterior'),
                  ),
                  DropdownMenuItem(
                    value: AnalyticsPeriod.currentYear,
                    child: Text('Este año'),
                  ),
                  DropdownMenuItem(
                    value: AnalyticsPeriod.all,
                    child: Text('Todo'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  ref
                      .read(analyticsPeriodProvider.notifier)
                      .state = value;
                },
              ),

              const SizedBox(height: 20),

              _SummaryCard(
                title: 'Ingresos',
                amount: income,
                icon: Icons.arrow_downward,
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _SummaryCard(
                title: 'Gastos',
                amount: expenses,
                icon: Icons.arrow_upward,
                color: Colors.red,
              ),

              const SizedBox(height: 12),

              _SummaryCard(
                title: 'Saldo',
                amount: balance,
                icon: Icons.account_balance_wallet,
                color: balance >= 0
                    ? Colors.green
                    : Colors.red,
              ),

              const SizedBox(height: 24),

              // Gráfico actual: ingresos vs gastos.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingresos vs. gastos',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment:
                                BarChartAlignment.spaceAround,
                            maxY: _chartMaxY(
                              income,
                              expenses,
                            ),
                            barTouchData: BarTouchData(
                              enabled: true,
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                ),
                              ),
                              rightTitles:
                                  const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              topTitles:
                                  const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (value, meta) {
                                    switch (
                                        value.toInt()) {
                                      case 0:
                                        return const Text(
                                          'Ingresos',
                                        );
                                      case 1:
                                        return const Text(
                                          'Gastos',
                                        );
                                      default:
                                        return const SizedBox
                                            .shrink();
                                    }
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            gridData:
                                const FlGridData(
                              show: true,
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: income,
                                    width: 45,
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.circular(
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: expenses,
                                    width: 45,
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.circular(
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Evolución mensual.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evolución mensual',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ingresos y gastos por mes',
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 280,
                        child: monthlyData.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay datos para mostrar',
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  minY: 0,
                                  maxY: _monthlyChartMaxY(
                                    monthlyData,
                                  ),
                                  gridData:
                                      const FlGridData(
                                    show: true,
                                  ),
                                  borderData:
                                      FlBorderData(
                                    show: false,
                                  ),
                                  lineTouchData:
                                      const LineTouchData(
                                    enabled: true,
                                  ),
                                  titlesData:
                                      FlTitlesData(
                                    topTitles:
                                        const AxisTitles(
                                      sideTitles:
                                          SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    rightTitles:
                                        const AxisTitles(
                                      sideTitles:
                                          SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    leftTitles:
                                        AxisTitles(
                                      sideTitles:
                                          SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                      ),
                                    ),
                                    bottomTitles:
                                        AxisTitles(
                                      sideTitles:
                                          SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget:
                                            (
                                          value,
                                          meta,
                                        ) {
                                          final index =
                                              value.toInt();

                                          if (index < 0 ||
                                              index >=
                                                  monthlyData
                                                      .length) {
                                            return const SizedBox
                                                .shrink();
                                          }

                                          return Padding(
                                            padding:
                                                const EdgeInsets
                                                    .only(
                                              top: 8,
                                            ),
                                            child: Text(
                                              monthlyData[
                                                  index].label,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: monthlyData
                                          .asMap()
                                          .entries
                                          .map(
                                        (entry) {
                                          return FlSpot(
                                            entry.key
                                                .toDouble(),
                                            entry.value
                                                .income,
                                          );
                                        },
                                      ).toList(),
                                      color: Colors.green,
                                      isCurved: true,
                                      barWidth: 3,
                                      dotData:
                                          const FlDotData(
                                        show: true,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: monthlyData
                                          .asMap()
                                          .entries
                                          .map(
                                        (entry) {
                                          return FlSpot(
                                            entry.key
                                                .toDouble(),
                                            entry.value
                                                .expenses,
                                          );
                                        },
                                      ).toList(),
                                      color: Colors.red,
                                      isCurved: true,
                                      barWidth: 3,
                                      dotData:
                                          const FlDotData(
                                        show: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          _ChartLegend(
                            label: 'Ingresos',
                            color: Colors.green,
                          ),
                          const SizedBox(width: 24),
                          _ChartLegend(
                            label: 'Gastos',
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _chartMaxY(double income, double expenses) {
    final maxValue = income > expenses ? income : expenses;

    if (maxValue <= 0) {
      return 100;
    }

    return maxValue * 1.2;
  }

  double _monthlyChartMaxY(
    List<_MonthlyData> data,
  ) {
    double maxValue = 0;

    for (final month in data) {
      if (month.income > maxValue) {
        maxValue = month.income;
      }

      if (month.expenses > maxValue) {
        maxValue = month.expenses;
      }
    }

    if (maxValue <= 0) {
      return 100;
    }

    return maxValue * 1.2;
  }

  List<_MonthlyData> _buildMonthlyData(
    List<Operation> operations,
  ) {
    if (operations.isEmpty) {
      return [];
    }

    final Map<String, _MonthlyData> grouped = {};

    for (final operation in operations) {
      final key =
          '${operation.date.year}-${operation.date.month}';

      final label = _monthLabel(
        operation.date.month,
      );

      final current = grouped[key];

      if (current == null) {
        grouped[key] = _MonthlyData(
          label: label,
          income: operation.type == OperationType.income
              ? operation.amount
              : 0,
          expenses:
              operation.type == OperationType.expense
                  ? operation.amount
                  : 0,
          year: operation.date.year,
          month: operation.date.month,
        );
      } else {
        grouped[key] = current.copyWith(
          income: operation.type == OperationType.income
              ? current.income + operation.amount
              : current.income,
          expenses:
              operation.type == OperationType.expense
                  ? current.expenses + operation.amount
                  : current.expenses,
        );
      }
    }

    final result = grouped.values.toList();

    result.sort((a, b) {
      if (a.year != b.year) {
        return a.year.compareTo(b.year);
      }

      return a.month.compareTo(b.month);
    });

    return result;
  }

  String _monthLabel(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    return months[month - 1];
  }

  List<Operation> _filterOperations(
    List<Operation> operations,
    AnalyticsPeriod period,
  ) {
    if (period == AnalyticsPeriod.all) {
      return operations;
    }

    final now = DateTime.now();

    late DateTime start;
    late DateTime end;

    switch (period) {
      case AnalyticsPeriod.currentMonth:
        start = DateTime(
          now.year,
          now.month,
        );

        end = DateTime(
          now.year,
          now.month + 1,
        );

      case AnalyticsPeriod.previousMonth:
        start = DateTime(
          now.year,
          now.month - 1,
        );

        end = DateTime(
          now.year,
          now.month,
        );

      case AnalyticsPeriod.currentYear:
        start = DateTime(
          now.year,
        );

        end = DateTime(
          now.year + 1,
        );

      case AnalyticsPeriod.all:
        return operations;
    }

    return operations.where((operation) {
      return !operation.date.isBefore(start) &&
          operation.date.isBefore(end);
    }).toList();
  }
}

class _MonthlyData {
  const _MonthlyData({
    required this.label,
    required this.income,
    required this.expenses,
    required this.year,
    required this.month,
  });

  final String label;
  final double income;
  final double expenses;
  final int year;
  final int month;

  _MonthlyData copyWith({
    double? income,
    double? expenses,
  }) {
    return _MonthlyData(
      label: label,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      year: year,
      month: month,
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${amount.toStringAsFixed(2)} €',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}