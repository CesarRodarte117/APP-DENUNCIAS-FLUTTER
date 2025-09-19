import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

export 'denuncia.dart';

class Denuncia {
  int? id;
  String? usuarioIdentificador;
  String? estatus;
  String? clave;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? sexo;
  String? edad;
  String? telefono;
  String? direccion;
  String? direccionNumero;
  String? colonia;
  String? correo;
  String? ocupacion;
  String? nacionalidad;
  String? numeroIdentificacion;

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
    this.usuarioIdentificador,
    this.estatus,
    this.clave,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.sexo,
    this.edad,
    this.telefono,
    this.direccion,
    this.direccionNumero,
    this.colonia,
    this.correo,
    this.ocupacion,
    this.nacionalidad,
    this.numeroIdentificacion,

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
      'usuarioIdentificador': usuarioIdentificador,
      'estatus': estatus,
      'clave': clave,
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'telefono': telefono,
      'correo': correo,
      'sexo': sexo,
      'edad': edad,
      'direccion': direccion,
      'direccionNumero': direccionNumero,
      'colonia': colonia,
      'nacionalidad': nacionalidad,
      'numeroIdentificacion': numeroIdentificacion,
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
      usuarioIdentificador: map['usuarioIdentificador'],
      estatus: map['estatus'],
      nombre: map['nombre'],
      apellidoPaterno: map['apellidoPaterno'],
      apellidoMaterno: map['apellidoMaterno'],
      sexo: map['sexo'],
      edad: map['edad'],
      telefono: map['telefono'],
      direccion: map['direccion'],
      direccionNumero: map['direccionNumero'],
      colonia: map['colonia'],
      correo: map['correo'],
      ocupacion: map['ocupacion'],
      nacionalidad: map['nacionalidad'],
      numeroIdentificacion: map['numeroIdentificacion'],
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
    return 'Denuncia{id: $id, usuarioIdentificador: $usuarioIdentificador, estatus: $estatus, nombre: $nombre, apellido Paterno: $apellidoPaterno, apellido Materno: $apellidoMaterno, telefono: $telefono, correo: $correo, sexo: $sexo, edad: $edad, direccion: $direccion, direccionNumero: $direccionNumero, colonia: $colonia, nacionalidad: $nacionalidad, numeroIdentificacion: $numeroIdentificacion, ocupacion: $ocupacion, servidorNombre: $servidorNombre, servidorCargo: $servidorCargo, servidorDependencia: $servidorDependencia, servidorIdentificacionDetalle: $servidorIdentificacionDetalle, servidorEcho: $servidorEcho, servidorDistrito: $servidorDistrito, servidorDireccion: $servidorDireccion, servidorDireccionCalles: $servidorDireccionCalles, servidorColonia: $servidorColonia, servidorEvidencia: $servidorEvidencia, servidorMotivo: $servidorMotivo, servidorFechaOcurrido: $servidorFechaOcurrido, fecha: $fecha, hora: $hora}';
  }

  Map<String, dynamic> toJson() {
    return {
      // ---- DATOS DE LA DENUNCIA ----
      "fecha_registro": fecha,
      "fecha_denuncia": servidorFechaOcurrido,
      "usuario": usuarioIdentificador,
      "estatus": estatus, // Dato fijo
      "peticion": servidorMotivo,
      "dependencia": servidorDependencia,
      "fuente": "APP", // Dato fijo
      "lugar_donde": "dependencia",
      "noid": numeroIdentificacion,

      // ---- UBICACIÓN DEL SUCESO ----
      "calle": servidorDireccion,
      "entrecalle": servidorDireccionCalles,
      "col_ubi": servidorColonia,
      "distrito": servidorDistrito,

      // ---- DATOS DEL DENUNCIANTE (TÚ) ----
      "nombre": nombre,
      "paterno": apellidoPaterno,
      "materno": apellidoMaterno,
      "genero":
          sexo, // Asegúrate que el valor sea 'H' o 'M' si la API lo requiere
      "direccion": direccion,
      "numero": direccionNumero,
      "colonia": colonia,
      "correo": correo,
      "telefono": telefono,
      "celular":
          telefono, // Puedes usar el mismo teléfono o tener un campo aparte
      "ocupacion": ocupacion,
      "edad": edad,
      "nacionalidad": nacionalidad,

      // ---- DATOS DEL DENUNCIADO (SERVIDOR PÚBLICO) ----
      "denunciado": servidorNombre,
      "cargo_desempena": servidorCargo,
      "identificacion": servidorIdentificacionDetalle,
      "otros": servidorDependencia,

      // ---- OTROS DATOS ----
      "queja_denuncia": "0",
      "imagenes": "1",
      "video": "0",
      "documentos": "0",

      // valores por defecto
      "novehiculo": "",
      "estado_civil": "",
    };
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
