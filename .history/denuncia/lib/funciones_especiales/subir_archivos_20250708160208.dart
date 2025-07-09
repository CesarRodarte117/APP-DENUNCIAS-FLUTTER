import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileUploadSection extends StatefulWidget {
  final String? tipoEvidencia; // Recibe el valor de tu dropdown
  final Function(String) onUrlObtenida; // Callback cuando se sube un archivo
  final Function(String) onError; // Callback para errores

  const FileUploadSection({
    super.key,
    required this.tipoEvidencia,
    required this.onUrlObtenida,
    required this.onError,
  });

  @override
  State<FileUploadSection> createState() => _FileUploadSectionState();
}

class _FileUploadSectionState extends State<FileUploadSection> {
  File? _archivoSeleccionado;
  bool _subiendo = false;
  String _nombreArchivo = '';
  String _tamanoArchivo = '';

  // Mapeo de tipos de dropdown a extensiones permitidas
  final Map<String, List<String>> _extensionesPermitidas = {
    'Imagenes': ['jpg', 'jpeg', 'png'],
    'Videos': ['mp4', 'mov'],
    'Documentos': ['pdf', 'doc', 'docx'],
  };

  Future<void> _seleccionarArchivo() async {
    if (widget.tipoEvidencia == null ||
        widget.tipoEvidencia == 'Select' ||
        !_extensionesPermitidas.containsKey(widget.tipoEvidencia)) {
      widget.onError('Selecciona un tipo de evidencia válido primero');
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _extensionesPermitidas[widget.tipoEvidencia]!,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _archivoSeleccionado = File(result.files.first.path!);
          _nombreArchivo = result.files.first.name;
          _tamanoArchivo = _formatearTamano(result.files.first.size);
        });
      }
    } catch (e) {
      widget.onError('Error al seleccionar archivo: ${e.toString()}');
    }
  }

  Future<void> _subirArchivo() async {
    if (_archivoSeleccionado == null) {
      widget.onError('No hay archivo seleccionado');
      return;
    }

    setState(() => _subiendo = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://apps.juarez.gob.mx/ws_cdenuncia/ws02/insertar_evidencia.json',
        ),
      );

      // Obtener extensión del archivo
      final extension = _nombreArchivo.split('.').last.toLowerCase();

      // Agregar parámetros
      request.fields['referencia'] =
          'REF-123'; // Aquí debes poner tu referencia real
      request.fields['tipo'] = extension;

      // Agregar archivo
      request.files.add(
        await http.MultipartFile.fromPath(
          'archivo',
          _archivoSeleccionado!.path,
          filename: _nombreArchivo,
        ),
      );

      // Enviar
      final response = await request.send();
      final respuesta = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonRespuesta = jsonDecode(respuesta);
        widget.onUrlObtenida(jsonRespuesta['resultado']);
      } else {
        widget.onError('Error al subir: ${response.statusCode}');
      }
    } catch (e) {
      widget.onError('Error de conexión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _subiendo = false);
      }
    }
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
        // Espacio para coincidir con tu estructura existente
        const SizedBox(height: 16),

        // Botón para seleccionar archivo
        ElevatedButton(
          onPressed: _subiendo ? null : _seleccionarArchivo,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('SELECCIONAR ARCHIVO'),
        ),

        const SizedBox(height: 16),

        // Vista previa del archivo seleccionado
        if (_archivoSeleccionado != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(_obtenerIconoPorTipo(), size: 40, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nombreArchivo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('Tamaño: $_tamañoArchivo'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Botón para subir archivo
          ElevatedButton(
            onPressed: _subiendo ? null : _subirArchivo,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child:
                _subiendo
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBIR ARCHIVO'),
          ),
        ],
      ],
    );
  }

  IconData _obtenerIconoPorTipo() {
    final extension = _nombreArchivo.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Icons.image;
    } else if (['mp4', 'mov'].contains(extension)) {
      return Icons.videocam;
    } else if (['pdf'].contains(extension)) {
      return Icons.picture_as_pdf;
    } else if (['doc', 'docx'].contains(extension)) {
      return Icons.description;
    }

    return Icons.insert_drive_file;
  }
}
