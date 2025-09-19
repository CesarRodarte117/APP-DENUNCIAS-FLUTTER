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
    print('ℹ️ No se encontró ID. Generando uno nuevo...');

    // Generamos un nuevo ID de 11 caracteres.
    var uuid = Uuid();
    String uuidCompleto = uuid.v4();
    String uuidSinGuiones = uuidCompleto.replaceAll('-', '');
    String nuevoIdentificador = uuidSinGuiones.substring(0, 11);

    // 4. GUARDAMOS el nuevo ID en el dispositivo para futuras ocasiones.
    await prefs.setString(idKey, nuevoIdentificador);

    print('📝 Nuevo ID guardado: $nuevoIdentificador');
    return nuevoIdentificador;
  }
}
