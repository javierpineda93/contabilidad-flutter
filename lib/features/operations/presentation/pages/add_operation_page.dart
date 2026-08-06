import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/operation.dart';
import '../providers/operation_providers.dart';
import '../../domain/entities/operation_type.dart';
import '../providers/add_operation_form_provider.dart';

class AddOperationPage extends ConsumerStatefulWidget {
  const AddOperationPage({super.key});

  @override
  ConsumerState<AddOperationPage> createState() =>
      _AddOperationPageState();
}

class _AddOperationPageState
    extends ConsumerState<AddOperationPage> {

  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  final _conceptController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addOperationFormProvider);

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
                        .read(
                          addOperationFormProvider.notifier,
                        )
                        .changeType(value);
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Importe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce un importe';
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
                  if (value == null || value.isEmpty) {
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
                  DateFormat('dd/MM/yyyy')
                      .format(form.date!),
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final date =
                      await showDatePicker(
                    context: context,
                    initialDate: form.date!,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    ref
                        .read(
                          addOperationFormProvider.notifier,
                        )
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

                  final operation = Operation.create(
                    type: form.type,
                    amount: amount,
                    concept: _conceptController.text.trim(),
                    date: form.date ?? DateTime.now(),
                  );

                  try {
                    final useCases = ref.read(operationUseCasesProvider);

                    await useCases.add(operation);
                    ref.invalidate(operationsProvider);


                    if (!mounted) return;

                    _amountController.clear();
                    _conceptController.clear();

                    ref.read(addOperationFormProvider.notifier).changeType(
                      OperationType.expense,
                    );

                    ref.read(addOperationFormProvider.notifier).changeDate(
                      DateTime.now(),
                    );

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Operación guardada correctamente'),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar: $e'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Guardar operación',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}