// Archivo: services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denuncia/models/denuncia.dart'; // Asegúrate que la ruta sea correcta

class ApiService {
  static Future<bool> subirDenuncia(Denuncia denuncia) async {
    const String url =
        'https://apps.juarez.gob.mx/ws_cdenuncia/ws01/insertar_denuncia.json';

    try {
      final denunciaJsonString = jsonEncode(denuncia.toJson());

      // Creamos un request tipo multipart/form-data
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Agregamos el campo "denuncia" como si fuera Postman
      request.fields['denuncia'] = denunciaJsonString;

      // Enviamos
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Respuesta del servidor: $data");

        if (data["resultado"] == "Exito" && data["mensaje"] != null) {
          denuncia.clave = data["mensaje"];
          print("📌 Clave asignada a denuncia: ${denuncia.clave}");
        }

        return true;
      } else {
        print("❌ Error: ${response.statusCode}");
        print("Detalle: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Excepción al intentar subir la denuncia: $e");
      return false;
    }
  }
}
