import 'dart:io'; // Necesario para detectar la plataforma (Platform.isIOS, etc.)
import 'package:device_info_plus/device_info_plus.dart';

Future<String> obtenerIdentificadorUnicoDispositivo() async {
  // 1. Instanciar el plugin
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String identificadorUnico = 'No se pudo obtener';

  try {
    // 2. Revisar si es iOS
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // Este es el ID único para tu app en este dispositivo
      identificadorUnico =
          iosInfo.identifierForVendor ?? 'No disponible en iOS';
    }
    // 3. Revisar si es Android
    else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // El 'id' es el Android ID. Es más consistente que serialNumber.
      identificadorUnico = androidInfo.id ?? 'No disponible en Android';
    }
  } catch (e) {
    // Si hay un error, lo puedes manejar aquí
    print('Error al obtener el identificador: $e');
  }

  return identificadorUnico;
}
