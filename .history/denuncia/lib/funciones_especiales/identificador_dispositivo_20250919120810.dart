import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<String> obtenerIdentificadorUnicoDispositivo() async {
  // Obtenemos una instancia de SharedPreferences.
  final prefs = await SharedPreferences.getInstance();

  // Definimos la clave donde guardaremos nuestro ID.
  const String idKey = 'identificador_unico_dispositivo';

  // 1. Intentamos LEER el identificador que ya podría estar guardado.
  String? identificadorGuardado = prefs.getString(idKey);

  // 2. Verificamos si encontramos algo.
  if (identificadorGuardado != null && identificadorGuardado.isNotEmpty) {
    // Si ya existe, lo retornamos y listo.
    print('✅ ID recuperado del dispositivo: $identificadorGuardado');
    return identificadorGuardado;
  } else {
    // 3. Si no existe, es la primera vez que se ejecuta la app.
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
