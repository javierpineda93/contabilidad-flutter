import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AnalyticsPeriod {
  currentMonth,
  previousMonth,
  currentYear,
  all,
}

final analyticsPeriodProvider =
    StateProvider<AnalyticsPeriod>(
  (ref) => AnalyticsPeriod.currentMonth,
);