import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistoryFilter {
  all,
  income,
  expense,
}

final historyFilterProvider =
    StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.all,
);