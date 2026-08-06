import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Formulario válido',
                        ),
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