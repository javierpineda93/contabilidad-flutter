import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/operation_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _exportBackup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final operations =
          await ref.read(operationsProvider.future);

      final service = ref.read(
        operationsBackupServiceProvider,
      );

      final outputPath =
          await service.exportOperations(operations);

      if (!context.mounted) {
        return;
      }

      if (outputPath == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Exportación cancelada.',
            ),
          ),
        );

        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Copia guardada con ${operations.length} '
            'operaciones.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Error al crear la copia: $e',
          ),
        ),
      );
    }
  }

  Future<void> _importBackup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null) {
        return;
      }

      final path = result.files.single.path;

      if (path == null || path.isEmpty) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo acceder al archivo seleccionado.',
            ),
          ),
        );

        return;
      }

      final file = File(path);

      final service = ref.read(
        operationsBackupServiceProvider,
      );

      // Primero validamos TODO el archivo.
      final backup = await service.readBackup(file);

      if (!context.mounted) {
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              'Copia de seguridad encontrada',
            ),
            content: Text(
              'La copia contiene '
              '${backup.operations.length} '
              'operaciones.\n\n'
              'Las operaciones se añadirán a las que '
              'ya existen en este dispositivo.\n\n'
              '¿Quieres continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Restaurar'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        return;
      }

      final operations = backup.operations
          .map((item) => item.toOperation())
          .toList();

      final useCases = ref.read(
        operationUseCasesProvider,
      );

      await useCases.restore(operations);

      // Obliga a Riverpod a volver a consultar SQLite.
      ref.invalidate(operationsProvider);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Restauración completada: '
            '${operations.length} '
            'operaciones importadas.',
          ),
        ),
      );
    } on FormatException catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Copia no válida: ${e.message}',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al restaurar la copia: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Datos'),
          ),
          ListTile(
            leading: const Icon(
              Icons.backup_outlined,
            ),
            title: const Text(
              'Exportar copia de seguridad',
            ),
            subtitle: const Text(
              'Guarda todas tus operaciones en un archivo JSON',
            ),
            onTap: () {
              _exportBackup(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.restore_outlined,
            ),
            title: const Text(
              'Importar copia de seguridad',
            ),
            subtitle: const Text(
              'Restaura operaciones desde un archivo JSON',
            ),
            onTap: () {
              _importBackup(context, ref);
            },
          ),
        ],
      ),
    );
  }
}