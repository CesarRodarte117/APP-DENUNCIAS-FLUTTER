import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:denuncia/models/db.dart';
import 'package:denuncia/models/denuncia.dart';

Future<void> guardarEvidenciasParaDenuncia({
  required int denunciaId,
  required List<File> archivos,
  required String tipoEvidencia,
}) async {
  try {
    if (archivos.isEmpty) return;

    final directory = await getApplicationDocumentsDirectory();
    final db = await DatabaseHelper().database;

    await db.transaction((txn) async {
      for (File archivo in archivos) {
        final nombreUnico =
            'denuncia_${denunciaId}_${DateTime.now().millisecondsSinceEpoch}_${path.basename(archivo.path)}';
        final destinoPath = path.join(directory.path, nombreUnico);

        await archivo.copy(destinoPath);

        final evidencia = Evidencia(
          denunciaId: denunciaId,
          url: '',
          pathLocal: destinoPath,
          tipo: tipoEvidencia,
          nombreArchivo: path.basename(archivo.path),
        );

        await txn.insert('evidencias', evidencia.toMap());
      }
    });
  } catch (e) {
    throw Exception('Error al guardar evidencias locales: $e');
  }
}
