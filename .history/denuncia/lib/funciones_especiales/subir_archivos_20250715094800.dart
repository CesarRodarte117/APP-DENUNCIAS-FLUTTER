import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:denuncia/models/denuncia.dart';
import 'package:denuncia/models/db.dart';

class FileUploadSection extends StatefulWidget {
  final Function(List<String>) onUrlsObtenidas;
  final Function(String) onError;
  final int maxArchivos;
  final int idDenuncia;

  const FileUploadSection({
    super.key,
    required this.onUrlsObtenidas,
    required this.onError,
    this.maxArchivos = 4,
    this.idDenuncia = 0,
  });

  @override
  State<FileUploadSection> createState() => FileUploadSectionState();
}

class FileUploadSectionState extends State<FileUploadSection> {
  List<File> _archivosSeleccionados = [];
  final Map<String, String> _nombresArchivos = {};
  final Map<String, String> _tamanosArchivos = {};
  int? _idDenuncia;

  // Todas las extensiones permitidas por el web service
  final List<String> _extensionesPermitidas = [
    'jpg', 'jpeg', 'png', // Imágenes
    'mp4', // Videos
    'mp3', 'wav', // audios
    'pdf', 'doc', 'docx', // Documentos
  ];

  Future<int> _obtenerIdDenuncia(idDenuncia) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'denuncia',
      where: 'id = ?',
      whereArgs: [idDenuncia],
    );

    if (maps.isNotEmpty) {
      _idDenuncia = idDenuncia;
      return maps.first['id'] as int;
    } else {
      throw Exception('Denuncia no encontrada');
    }
  }

  String _determinarTipoArchivo(String path) {
    final extension = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(extension)) return 'imagen';
    if (['pdf', 'doc', 'docx'].contains(extension)) return 'documento';
    if (['mp4'].contains(extension)) return 'video';
    if (['mp3', 'wav'].contains(extension)) return 'audio';
    return 'archivo';
  }

  Future<void> _seleccionarArchivos() async {
    if (_archivosSeleccionados.length >= widget.maxArchivos) {
      widget.onError('Máximo ${widget.maxArchivos} archivos permitidos');
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _extensionesPermitidas,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        int espaciosDisponibles =
            widget.maxArchivos - _archivosSeleccionados.length;
        int archivosAAgregar =
            result.files.length > espaciosDisponibles
                ? espaciosDisponibles
                : result.files.length;

        if (archivosAAgregar < result.files.length) {
          widget.onError(
            'Solo se agregaron $archivosAAgregar de ${result.files.length} archivos (límite: ${widget.maxArchivos})',
          );
        }

        setState(() {
          for (int i = 0; i < archivosAAgregar; i++) {
            final file = result.files[i];
            final filePath = file.path!;
            final fileKey = path.basename(filePath);

            _archivosSeleccionados.add(File(filePath));
            _nombresArchivos[fileKey] = file.name;
            _tamanosArchivos[fileKey] = _formatearTamano(file.size);
          }
        });
      }
    } catch (e) {
      widget.onError('Error al seleccionar archivos: ${e.toString()}');
    }
  }

  //GUARDAR ARCHIVOS SELECCIONADOS LOCALMENTE
  Future<void> guardarEvidenciasLocales(
    int denunciaId, [
    List<String> urls = const [],
  ]) async {
    try {
      print(
        '🟡 Intentando guardar ${_archivosSeleccionados.length} archivos con ID: $denunciaId',
      );
      if (_archivosSeleccionados.isEmpty) return;

      final directory = await getApplicationDocumentsDirectory();
      final evidencias = <Evidencia>[];

      for (var i = 0; i < _archivosSeleccionados.length; i++) {
        final archivo = _archivosSeleccionados[i];
        final nombreUnico =
            'denuncia_${denunciaId}_${DateTime.now().millisecondsSinceEpoch}_${path.basename(archivo.path)}';
        final localPath = path.join(directory.path, nombreUnico);
        // 1. Copiar el archivo (esperar explícitamente)
        await archivo.copy(localPath);

        // 2. Forzar sincronización del sistema de archivos (MÉTODO MEJORADO)
        final file = File(localPath);
        await file.exists(); // Verificación básica
        await file.readAsBytes().then(
          (bytes) => file.writeAsBytes(bytes),
        ); // Forzar refresco
        await file.exists(); // Doble verificación
        print('🟢 Archivo guardado localmente: ${file.path}');

        final evidencia = Evidencia(
          denunciaId: denunciaId,
          url: i < urls.length ? urls[i] : '', // usa URL si hay
          pathLocal: localPath,
          tipo: _determinarTipoArchivo(archivo.path) ?? 'archivo_desconocido',
          nombreArchivo: path.basename(archivo.path) ?? 'archivo_$i',
        );

        evidencias.add(evidencia);
      }

      final db = await DatabaseHelper().database;
      await db.transaction((txn) async {
        for (int i = 0; i < _archivosSeleccionados.length; i++) {
          await txn.insert('evidencias', evidencias[i].toMap());
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evidencias guardadas localmente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar evidencias: ${e.toString()}'),
          ),
        );
      }
      print('🔴 Error al guardar evidencias: ${e.toString()}');
      rethrow;
    }
  }

  bool _archivoEsDemasiadoGrande(File archivo) {
    const limiteMB = 199;
    final sizeInMB = archivo.lengthSync() / (1024 * 1024);
    return sizeInMB > limiteMB;
  }

  // Función pública para subir archivos desde el padre
  Future<bool> subirArchivos(String referenciaDenuncia) async {
    if (_archivosSeleccionados.isEmpty) {
      return true; // No hay archivos para subir, pero no es un error
    }

    List<String> urlsSubidas = [];

    try {
      for (var archivo in _archivosSeleccionados) {
        final fileName = path.basename(archivo.path);
        final extension = fileName.split('.').last.toLowerCase();

        bool archivoDemasiadoGrande = _archivoEsDemasiadoGrande(archivo);

        // Manejo de archivos grandes
        if (archivoDemasiadoGrande) {
          widget.onError(
            'El archivo $fileName es demasiado grande para subir (máximo 199MB).',
          );
          return false; // Saltar este archivo y continuar con los demás
        }

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            'https://apps.juarez.gob.mx/ws_cdenuncia/ws02/insertar_evidencia.json',
          ),
        );

        request.fields['referencia'] = referenciaDenuncia;
        request.fields['tipo'] = extension;
        request.files.add(
          await http.MultipartFile.fromPath(
            'archivo',
            archivo.path,
            filename: fileName,
          ),
        );

        final response = await request.send();
        final respuesta = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final jsonRespuesta = jsonDecode(respuesta);
          urlsSubidas.add(jsonRespuesta['resultado']);
        } else {
          widget.onError('Error al subir $fileName: ${response.statusCode}');
          return false;
        }
      }

      if (urlsSubidas.isNotEmpty) {
        widget.onUrlsObtenidas(urlsSubidas);
      }
      return true;
    } catch (e) {
      widget.onError('Error al subir archivos, intentelo de nuevo.');
      return false;
    }
  }

  void _eliminarArchivo(int index) {
    setState(() {
      final fileKey = path.basename(_archivosSeleccionados[index].path);
      _archivosSeleccionados.removeAt(index);
      _nombresArchivos.remove(fileKey);
      _tamanosArchivos.remove(fileKey);
    });
  }

  String _formatearTamano(int bytes) {
    if (bytes <= 0) return '0 B';
    const sufijos = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${sufijos[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Archivos seleccionados: ${_archivosSeleccionados.length}/${widget.maxArchivos}',
          style: TextStyle(
            color:
                _archivosSeleccionados.length >= widget.maxArchivos
                    ? Colors.red
                    : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:
              _archivosSeleccionados.length >= widget.maxArchivos
                  ? null
                  : _seleccionarArchivos,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('SELECCIONAR ARCHIVOS'),
        ),
        const SizedBox(height: 16),
        if (_archivosSeleccionados.isNotEmpty) ...[
          ..._archivosSeleccionados.asMap().entries.map((entry) {
            final index = entry.key;
            final archivo = entry.value;
            final fileName = path.basename(archivo.path);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _obtenerIconoPorTipo(fileName),
                    size: 40,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nombresArchivos[fileName] ?? fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('Tamaño: ${_tamanosArchivos[fileName]}'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _eliminarArchivo(index),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  IconData _obtenerIconoPorTipo(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Icons.image;
    } else if (['mp4'].contains(extension)) {
      return Icons.videocam;
    } else if (['mp3', 'wav'].contains(extension)) {
      return Icons.audiotrack;
    } else if (['pdf'].contains(extension)) {
      return Icons.picture_as_pdf;
    } else if (['doc', 'docx'].contains(extension)) {
      return Icons.description;
    }

    return Icons.insert_drive_file;
  }
}
