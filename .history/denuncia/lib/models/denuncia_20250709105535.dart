import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

export 'denuncia.dart';

class Denuncia {
  int? id;
  String? nombre;
  String? apellidos;
  String? sexo;
  String? edad;
  String? telefono;
  String? direccion;
  String? direccionNumero;
  String? colonia;
  String? correo;
  String? ocupacion;
  String? nacionalidad;
  String servidorNombre;
  String servidorCargo;
  String servidorDependencia;
  String servidorIdentificacionDetalle;
  String servidorEcho;
  String servidorDistrito;
  String servidorDireccion;
  String servidorDireccionCalles;
  String servidorColonia;
  String servidorEvidencia;
  String servidorMotivo;
  String servidorFechaOcurrido;
  String fecha;
  String hora;

  Denuncia({
    this.id,
    this.nombre,
    this.apellidos,
    this.sexo,
    this.edad,
    this.telefono,
    this.direccion,
    this.direccionNumero,
    this.colonia,
    this.correo,
    this.ocupacion,
    this.nacionalidad,

    required this.servidorNombre,
    required this.servidorCargo,
    required this.servidorDependencia,
    required this.servidorIdentificacionDetalle,
    required this.servidorEcho,
    required this.servidorDistrito,
    required this.servidorDireccion,
    required this.servidorDireccionCalles,
    required this.servidorColonia,
    required this.servidorEvidencia,
    required this.servidorMotivo,
    required this.servidorFechaOcurrido,
    required this.fecha,
    required this.hora,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
      'sexo': sexo,
      'edad': edad,
      'direccion': direccion,
      'direccionNumero': direccionNumero,
      'colonia': colonia,
      'nacionalidad': nacionalidad,
      'ocupacion': ocupacion,
      'servidorNombre': servidorNombre,
      'servidorCargo': servidorCargo,
      'servidorDependencia': servidorDependencia,
      'servidorIdentificacionDetalle': servidorIdentificacionDetalle,
      'servidorEcho': servidorEcho,
      'servidorDistrito': servidorDistrito,
      'servidorDireccion': servidorDireccion,
      'servidorDireccionCalles': servidorDireccionCalles,
      'servidorColonia': servidorColonia,
      'servidorEvidencia': servidorEvidencia,
      'servidorMotivo': servidorMotivo,
      'servidorFechaOcurrido': servidorFechaOcurrido,
      'fecha': fecha,
      'hora': hora,
    };
  }

  factory Denuncia.fromMap(Map<String, dynamic> map) {
    return Denuncia(
      id: map['id'],
      nombre: map['nombre'],
      apellidos: map['apellidos'],
      sexo: map['sexo'],
      edad: map['edad'],
      telefono: map['telefono'],
      direccion: map['direccion'],
      direccionNumero: map['direccionNumero'],
      colonia: map['colonia'],
      correo: map['correo'],
      ocupacion: map['ocupacion'],
      nacionalidad: map['nacionalidad'],
      servidorNombre: map['servidorNombre'] ?? '',
      servidorCargo: map['servidorCargo'] ?? '',
      servidorDependencia: map['servidorDependencia'] ?? '',
      servidorIdentificacionDetalle: map['servidorIdentificacionDetalle'] ?? '',
      servidorEcho: map['servidorEcho'] ?? '',
      servidorDistrito: map['servidorDistrito'] ?? '',
      servidorDireccion: map['servidorDireccion'] ?? '',
      servidorDireccionCalles: map['servidorDireccionCalles'] ?? '',
      servidorColonia: map['servidorColonia'] ?? '',
      servidorEvidencia: map['servidorEvidencia'] ?? '',
      servidorMotivo: map['servidorMotivo'] ?? '',
      servidorFechaOcurrido: map['servidorFechaOcurrido'] ?? '',
      fecha: map['fecha'] ?? '',
      hora: map['hora'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Denuncia{id: $id, nombre: $nombre, apellidos: $apellidos, telefono: $telefono, correo: $correo, sexo: $sexo, edad: $edad, direccion: $direccion, direccionNumero: $direccionNumero, colonia: $colonia, nacionalidad: $nacionalidad, ocupacion: $ocupacion, servidorNombre: $servidorNombre, servidorCargo: $servidorCargo, servidorDependencia: $servidorDependencia, servidorIdentificacionDetalle: $servidorIdentificacionDetalle, servidorEcho: $servidorEcho, servidorDistrito: $servidorDistrito, servidorDireccion: $servidorDireccion, servidorDireccionCalles: $servidorDireccionCalles, servidorColonia: $servidorColonia, servidorEvidencia: $servidorEvidencia, servidorMotivo: $servidorMotivo, servidorFechaOcurrido: $servidorFechaOcurrido, fecha: $fecha, hora: $hora}';
  }
}

class Evidencia {
  final int? id;
  final int denunciaId;
  final String url;
  final String? pathLocal;
  final String tipo;
  final String nombreArchivo;

  Evidencia({
    this.id,
    required this.denunciaId,
    required this.url,
    this.pathLocal,
    required this.tipo,
    required this.nombreArchivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'denuncia_id': denunciaId,
      'url': url,
      'path_local': pathLocal,
      'tipo': tipo,
      'nombre_archivo': nombreArchivo,
    };
  }

  factory Evidencia.fromMap(Map<String, dynamic> map) {
    return Evidencia(
      id: map['id'],
      denunciaId: map['denuncia_id'],
      url: map['url'],
      pathLocal: map['path_local'],
      tipo: map['tipo'],
      nombreArchivo: map['nombre_archivo'],
    );
  }
}

Future<bool> guardarEvidenciasLocales({
  required int denunciaId,
  required List<File> archivos,
  required List<String> urls,
  required DatabaseHelper dbHelper,
}) async {
  try {
    // Verificar que coincidan las cantidades
    if (archivos.length != urls.length) {
      throw Exception('La cantidad de archivos no coincide con las URLs');
    }

    // Procesar cada archivo
    for (int i = 0; i < archivos.length; i++) {
      final archivo = archivos[i];
      final url = urls[i];

      // Obtener extensión del archivo
      final extension = archivo.path.split('.').last.toLowerCase();

      // Generar nombre único para el archivo local
      final nombreArchivo =
          'evidencia_${denunciaId}_${DateTime.now().millisecondsSinceEpoch}_$i.$extension';

      // Guardar copia local del archivo
      final archivoLocal = await _guardarArchivoLocal(archivo, nombreArchivo);

      // Crear objeto Evidencia
      final evidencia = Evidencia(
        denunciaId: denunciaId,
        url: url,
        pathLocal: archivoLocal.path,
        tipo: extension,
        nombreArchivo: nombreArchivo,
      );

      // Insertar en la base de datos
      await dbHelper.insertEvidencia(evidencia);
    }

    return true;
  } catch (e) {
    print('Error al guardar evidencias: $e');
    return false;
  }
}

Future<File> _guardarArchivoLocal(File archivo, String nombreArchivo) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$nombreArchivo';
  return await archivo.copy(path);
}
