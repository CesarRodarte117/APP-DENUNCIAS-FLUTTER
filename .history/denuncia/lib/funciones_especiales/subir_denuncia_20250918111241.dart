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

class api_denuncia extends StatefulWidget {
  const api_denuncia({super.key, required this.onError});
  final Function(String) onError;

  @override
  State<api_denuncia> createState() => _api_denuncia_State();
}

class _api_denuncia_State extends State<api_denuncia> {
  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);
  late final Denuncia denuncia;

  static const String _url =
      'https://apps.juarez.gob.mx/ws_cdenuncia/ws01/insertar_denuncia.json';
  // Función pública para subir archivos desde el padre
  Future<bool> subir_denuncia(String referenciaDenuncia) async {
    try {
      final denunciaJson = denuncia.toJson(); // tu modelo debe tener toJson()

      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "denuncia": jsonEncode(denunciaJson), // <- se envía como string
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Respuesta servidor: $data");
        return true;
      } else {
        print(" Error: ${response.statusCode} ${response.body}");
        return false;
      }
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
