import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/utils/operation_history_filter.dart';

final historyFilterProvider =
    StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.all,
);