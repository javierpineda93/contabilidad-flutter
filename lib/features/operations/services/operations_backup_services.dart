import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../domain/entities/operation.dart';
import '../data/models/operations_backup_model.dart';

class OperationsBackupService {
  Future<String?> exportOperations(
    List<Operation> operations,
  ) async {
    final backup = OperationsBackupModel.fromOperations(
      operations,
    );

    final json = const JsonEncoder.withIndent(
      '  ',
    ).convert(backup.toJson());

    final bytes = utf8.encode(json);

    final date = DateTime.now();

    final fileName =
        'contabilidad_backup_'
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}.json';

    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar copia de seguridad',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );

    return outputPath;
  }

  Future<OperationsBackupModel> readBackup(
    File file,
  ) async {
    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      throw const FormatException(
        'La copia de seguridad está vacía.',
      );
    }

    final decoded = jsonDecode(content);

    if (decoded is! Map) {
      throw const FormatException(
        'El archivo no contiene una copia de seguridad válida.',
      );
    }

    try {
      return OperationsBackupModel.fromJson(
        Map<String, dynamic>.from(decoded),
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException(
        'No se pudo leer la copia de seguridad: $e',
      );
    }
  }
}