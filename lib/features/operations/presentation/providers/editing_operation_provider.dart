import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/operation.dart';

final editingOperationProvider =
    StateProvider<Operation?>((ref) => null);