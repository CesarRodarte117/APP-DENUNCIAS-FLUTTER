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

class cargar_denuncia extends StatefulWidget {
  const cargar_denuncia({super.key, required this.onError});
  final Function(String) onError;

  @override
  State<cargar_denuncia> createState() => _cargar_denunciaState();
}

class _cargar_denunciaState extends State<cargar_denuncia> {
  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();

  // Función pública para subir archivos desde el padre
  Future<bool> subirArchivos(String referenciaDenuncia) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://apps.juarez.gob.mx/ws_cdenuncia/ws02/insertar_evidencia.json',
        ),
      );

      final response = await request.send();
      final respuesta = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonRespuesta = jsonDecode(respuesta);
      } else {
        widget.onError('Error al subir : ${response.statusCode}');
        return false;
      }

      // if (urlsSubidas.isNotEmpty) {
      //   widget.onUrlsObtenidas(urlsSubidas);
      // }

      return true;
    } catch (e) {
      widget.onError('Error al subir archivos, intentelo de nuevo.');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
