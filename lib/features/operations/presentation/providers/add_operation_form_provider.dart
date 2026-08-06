import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/operation_type.dart';

class AddOperationFormState {
  const AddOperationFormState({
    this.type = OperationType.expense,
    this.date,
  });

  final OperationType type;
  final DateTime? date;

  AddOperationFormState copyWith({
    OperationType? type,
    DateTime? date,
  }) {
    return AddOperationFormState(
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}

class AddOperationFormNotifier
    extends StateNotifier<AddOperationFormState> {

  AddOperationFormNotifier()
      : super(
          AddOperationFormState(
            date: DateTime.now(),
          ),
        );

  void changeType(OperationType type) {
    state = state.copyWith(type: type);
  }

  void changeDate(DateTime date) {
    state = state.copyWith(date: date);
  }
}

final addOperationFormProvider =
    StateNotifierProvider<
        AddOperationFormNotifier,
        AddOperationFormState>(
  (ref) => AddOperationFormNotifier(),
);