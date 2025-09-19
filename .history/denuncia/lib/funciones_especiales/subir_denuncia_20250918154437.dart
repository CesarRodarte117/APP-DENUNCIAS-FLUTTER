// Archivo: services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denuncia/models/denuncia.dart'; // Asegúrate que la ruta sea correcta

class ApiService {
  // Hacemos la función 'static' para poder llamarla directamente desde la clase.
  static Future<bool> subirDenuncia(Denuncia denuncia) async {
    const String url =
        'https://apps.juarez.gob.mx/ws_cdenuncia/ws01/insertar_denuncia.json';

    try {
      final denunciaJson = denuncia.toJson();
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(denunciaJson),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Respuesta del servidor: $data");
        return true; // Éxito
      } else {
        print("❌ Error: ${response.statusCode}");
        print("Detalle: ${response.body}");
        return false; // Error
      }
    } catch (e) {
      print("❌ Excepción al intentar subir la denuncia: $e");
      return false; // Error
    }
  }
}
