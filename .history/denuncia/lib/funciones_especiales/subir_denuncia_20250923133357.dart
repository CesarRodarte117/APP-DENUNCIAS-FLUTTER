// Archivo: services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denuncia/models/denuncia.dart';

// --- CLASE PARA MANEJAR EL RESUMEN DE LA DENUNCIA ---
class DenunciaResumen {
  final String clave;
  final String estatus;

  DenunciaResumen({required this.clave, required this.estatus});

  // Factory constructor para crear una instancia desde un mapa JSON.
  factory DenunciaResumen.fromJson(Map<String, dynamic> json) {
    return DenunciaResumen(
      clave: json['clave'] as String,
      estatus: json['estatus'] as String,
    );
  }
}

// --- SERVICIO DE LA API ---
class ApiService {
  /// Envía una nueva denuncia al servidor.
  static Future<bool> subirDenuncia(Denuncia denuncia) async {
    const String url =
        'https://apps.juarez.gob.mx/ws_cdenuncia/ws01/insertar_denuncia.json';

    try {
      final denunciaJsonString = jsonEncode(denuncia.toJson());
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['denuncia'] = denunciaJsonString;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Respuesta del servidor (subirDenuncia): $data");

        if (data["resultado"] == "Exito" && data["mensaje"] != null) {
          // Asignamos la clave que nos devuelve el servidor al objeto denuncia local.
          denuncia.clave = data["mensaje"];
          print("📌 Clave asignada a denuncia: ${denuncia.clave}");
          return true;
        }
        return false;
      } else {
        print("❌ Error en subirDenuncia: ${response.statusCode}");
        print("Detalle: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Excepción en subirDenuncia: $e");
      return false;
    }
  }

  /// Obtiene una lista con la clave y estatus de las denuncias de un usuario.
  static Future<List<DenunciaResumen>> ObtenerDenunciasPorUsuario(
    String usuarioIdentificador,
  ) async {
    // Para una petición GET, los parámetros van en la URL.
    final url = Uri.https(
      'apps.juarez.gob.mx',
      '/ws_cdenuncia/ws01/gestion_denuncias_por_usuario.json',
      {'usuario': usuarioIdentificador},
    );

    try {
      // Usamos http.get, que es el método para esta solicitud.
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verificamos que la respuesta del servidor sea exitosa y que "resultado" sea una lista.
        if (data["mensaje"] == "Exito" && data["resultado"] is List) {
          final List<dynamic> resultadosJson = data["resultado"];

          // Convertimos cada elemento del JSON en un objeto DenunciaResumen.
          final List<DenunciaResumen> denuncias =
              resultadosJson
                  .map((item) => DenunciaResumen.fromJson(item))
                  .toList();

          print("✅ Se encontraron ${denuncias.length} denuncias.");
          return denuncias; // Retornamos la lista de denuncias.
        } else {
          print("⚠️ El servidor respondió pero sin resultados válidos.");
          return []; // Retornamos una lista vacía.
        }
      } else {
        print("❌ Error en ObtenerDenunciasPorUsuario: ${response.statusCode}");
        print("Detalle: ${response.body}");
        return []; // En caso de error, retornamos una lista vacía.
      }
    } catch (e) {
      print("❌ Excepción en ObtenerDenunciasPorUsuario: $e");
      return []; // En caso de excepción, retornamos una lista vacía.
    }
  }

  // eliminar evidencia
  static Future<bool> eliminarEvidenciaServidor(String urlEvidencia) async {
    const String baseUrl = 'apps.juarez.gob.mx';
    const String path = '/ws_cdenuncia/ws02/eliminar_evidencia.json';

    // La 'referencia' es la URL única de la evidencia que quieres borrar.
    final url = Uri.https(baseUrl, path, {'referencia': urlEvidencia});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['resultado'] == 'Exito') {
          print('✅ Evidencia eliminada del servidor exitosamente.');
          return true;
        } else {
          print(
            '⚠️ El servidor respondió, pero no se pudo eliminar: ${data['mensaje']}',
          );
          return false;
        }
      } else {
        print(
          '❌ Error de servidor al intentar eliminar: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Excepción al eliminar evidencia del servidor: $e');
      return false;
    }
  }
}
