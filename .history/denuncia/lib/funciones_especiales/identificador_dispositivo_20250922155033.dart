import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<String> obtenerIdentificadorUnicoDispositivo() async {
  final prefs = await SharedPreferences.getInstance();

  const String idKey = 'identificador_unico_dispositivo';

  String? identificadorGuardado = prefs.getString(idKey);

  if (identificadorGuardado != null && identificadorGuardado.isNotEmpty) {
    print('✅ ID recuperado del dispositivo: $identificadorGuardado');
    return identificadorGuardado;
  } else {
    // Generamos un nuevo ID de 11 caracteres.
    var uuid = Uuid();
    String uuidCompleto = uuid.v4();
    String uuidSinGuiones = uuidCompleto.replaceAll('-', '');
    String nuevoIdentificador = uuidSinGuiones.substring(0, 11);

    await prefs.setString(idKey, nuevoIdentificador);

    return nuevoIdentificador;
  }
}
