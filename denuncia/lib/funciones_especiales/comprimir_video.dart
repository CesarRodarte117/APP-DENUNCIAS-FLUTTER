//ESTE CODIO ES UNA PARTE "SUBIR_ARCHIVOS" DE UNA FUNCION ESPECIAL
// QUE SE UTILIZA PARA COMPRIMIR VIDEOS ANTES DE SUBIRLOS A UN SERVIDOR
// EN UNA APLICACION FLUTTER PARA DENUNCIAS.

//ffmpeg
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';

  // Future<File?> _comprimirVideo(File videoOriginal) async {
  //   try {
  //     final directory = await getTemporaryDirectory();
  //     final outputPath = path.join(
  //       directory.path,
  //       'compressed__${path.basename(videoOriginal.path)}',
  //     );

  //     // Calcular tamaño original
  //     final originalSizeMB = videoOriginal.lengthSync() / (1024 * 1024);
  //     print('📦 Tamaño original: ${originalSizeMB.toStringAsFixed(2)} MB');

  //     //     '-i "${videoOriginal.path}" -preset ultrafast -crf 35 -c:a copy "$outputPath"';

  //     // Construir el comando FFmpeg
  //     final command =
  //         '-i "${videoOriginal.path}" '
  //         '-preset veryfast '
  //         '-crf 28 '
  //         '-movflags +faststart '
  //         '-vf "scale=-2:720" '
  //         '-c:a aac '
  //         '-b:a 128k '
  //         '-threads 2 '
  //         '"$outputPath"';

  //     print('⚙️ Ejecutando compresión...');
  //     final session = await FFmpegKit.execute(command);

  //     final returnCode = await session.getReturnCode();
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       final compressedFile = File(outputPath);
  //       final compressedSizeMB = compressedFile.lengthSync() / (1024 * 1024);

  //       print('✅ Compresión exitosa');
  //       print('📊 Tamaños:');
  //       print('   Antes: ${originalSizeMB.toStringAsFixed(2)} MB');
  //       print('   Después: ${compressedSizeMB.toStringAsFixed(2)} MB');
  //       print(
  //         '   Reducción: ${((originalSizeMB - compressedSizeMB) / originalSizeMB * 100).toStringAsFixed(2)}%',
  //       );

  //       return compressedFile;
  //     } else {
  //       final output = await session.getOutput();
  //       print('❌ Error al comprimir: ${await session.getFailStackTrace()}');
  //       print('🔍 Output: $output');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('‼️ Error en compresión: $e');
  //     return null;
  //   }
  // }



        // if (['mp4'].contains(extension)) {
        //   // Comprimir video si es necesario
        //   print('Comprobando compresión de video: $fileName');
        //   print('archivo: ${archivo.path}');
        //   final videoComprimido = await _comprimirVideo(archivo);
        //   if (videoComprimido != null) {
        //     archivo = videoComprimido;
        //     print('Video comprimido: ${videoComprimido.path}');
        //   }
        // }