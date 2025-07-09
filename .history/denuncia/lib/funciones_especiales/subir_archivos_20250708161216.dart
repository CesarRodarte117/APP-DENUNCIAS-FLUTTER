class MultiFileUploadSection extends StatefulWidget {
  final String? tipoEvidencia;
  final Function(List<String>) onUrlsObtenidas;
  final Function(String) onError;
  final int maxArchivos;

  const MultiFileUploadSection({
    super.key,
    required this.tipoEvidencia,
    required this.onUrlsObtenidas,
    required this.onError,
    this.maxArchivos = 4,
  });

  @override
  State<MultiFileUploadSection> createState() => _MultiFileUploadSectionState();
}

class _MultiFileUploadSectionState extends State<MultiFileUploadSection> {
  List<File> _archivosSeleccionados = [];
  final Map<String, String> _nombresArchivos = {};
  final Map<String, String> _tamanosArchivos = {};

  // Método público para iniciar la subida desde el padre
  Future<bool> subirArchivos() async {
    if (_archivosSeleccionados.isEmpty) {
      widget.onError('No hay archivos seleccionados');
      return false;
    }

    List<String> urlsSubidas = [];

    try {
      for (var archivo in _archivosSeleccionados) {
        final fileName = path.basename(archivo.path);
        final extension = fileName.split('.').last.toLowerCase();

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            'https://apps.juarez.gob.mx/ws_cdenuncia/ws02/insertar_evidencia.json',
          ),
        );

        request.fields['referencia'] =
            'REF-123'; // Usará la referencia real de la denuncia
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
        return true;
      }
    } catch (e) {
      widget.onError('Error de conexión: ${e.toString()}');
      return false;
    }

    return false;
  }

  // ... (mantén todos los otros métodos igual que antes excepto build)

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Contador de archivos
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

        // Botón para seleccionar archivos
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

        // Lista de archivos seleccionados
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
}
