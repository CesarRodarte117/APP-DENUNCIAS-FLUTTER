  Future<bool> subirArchivos(String referenciaDenuncia) async {
    if (_archivosSeleccionados.isEmpty) {
      return true; // No hay archivos para subir, pero no es un error
    }

    List<String> urlsSubidas = [];

    try {
      for (var archivo in _archivosSeleccionados) {
        final fileName = path.basename(archivo.path);
        final extension = fileName.split('.').last.toLowerCase();

        // Manejo de archivos grandes
        if (_archivoEsDemasiadoGrande(archivo)) {
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