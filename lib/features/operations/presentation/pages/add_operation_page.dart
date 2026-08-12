import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/operation.dart';
import '../../domain/entities/operation_type.dart';
import '../providers/add_operation_form_provider.dart';
import '../providers/editing_operation_provider.dart';
import '../providers/operation_providers.dart';

class AddOperationPage extends ConsumerStatefulWidget {
  const AddOperationPage({super.key});

  @override
  ConsumerState<AddOperationPage> createState() =>
      _AddOperationPageState();
}

class _AddOperationPageState extends ConsumerState<AddOperationPage> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  final _conceptController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual<Operation?>(
      editingOperationProvider,
      (previous, next) {
        if (next == null) {
          return;
        }

        _loadOperation(next);
      },
    );

    final editingOperation = ref.read(editingOperationProvider);

    if (editingOperation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        _loadOperation(editingOperation);
      });
    }
  }

  void _loadOperation(Operation operation) {
    _amountController.text = operation.amount.toString();
    _conceptController.text = operation.concept;

    ref
        .read(addOperationFormProvider.notifier)
        .changeType(operation.type);

    ref
        .read(addOperationFormProvider.notifier)
        .changeDate(operation.date);
  }

  void _clearForm() {
    _amountController.clear();
    _conceptController.clear();

    ref
        .read(addOperationFormProvider.notifier)
        .changeType(OperationType.expense);

    ref
        .read(addOperationFormProvider.notifier)
        .changeDate(DateTime.now());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addOperationFormProvider);
    final editingOperation = ref.watch(editingOperationProvider);

    final isEditing = editingOperation != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<OperationType>(
                initialValue: form.type,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                ),
                items: OperationType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(addOperationFormProvider.notifier)
                        .changeType(value);
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Importe',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduce un importe';
                  }

                  final amount = double.tryParse(
                    value.replaceAll(',', '.'),
                  );

                  if (amount == null || amount <= 0) {
                    return 'Introduce un importe válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _conceptController,
                decoration: const InputDecoration(
                  labelText: 'Concepto',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduce un concepto';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha'),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy').format(form.date!),
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: form.date!,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    ref
                        .read(addOperationFormProvider.notifier)
                        .changeDate(date);
                  }
                },
              ),

              const SizedBox(height: 32),

              FilledButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final messenger = ScaffoldMessenger.of(context);

                  final amount = double.tryParse(
                    _amountController.text.replaceAll(',', '.'),
                  );

                  if (amount == null) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('El importe no es válido'),
                      ),
                    );
                    return;
                  }

                  final operation = isEditing
                      ? editingOperation.copyWith(
                          type: form.type,
                          amount: amount,
                          concept: _conceptController.text.trim(),
                          date: form.date ?? DateTime.now(),
                          updatedAt: DateTime.now(),
                        )
                      : Operation.create(
                          type: form.type,
                          amount: amount,
                          concept: _conceptController.text.trim(),
                          date: form.date ?? DateTime.now(),
                        );

                  try {
                    final useCases = ref.read(
                      operationUseCasesProvider,
                    );

                    if (isEditing) {
                      await useCases.update(operation);
                    } else {
                      await useCases.add(operation);
                    }

                    ref.invalidate(operationsProvider);

                    ref
                        .read(editingOperationProvider.notifier)
                        .state = null;

                    if (!mounted) {
                      return;
                    }

                    _clearForm();

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Operación actualizada correctamente'
                              : 'Operación guardada correctamente',
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Error al actualizar: $e'
                              : 'Error al guardar: $e',
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  isEditing
                      ? 'Actualizar operación'
                      : 'Guardar operación',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}