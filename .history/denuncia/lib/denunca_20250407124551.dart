import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  DateTime? nacionalidad;

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
    };
  }

  @override
  String toString() {
    return 'Denuncia{id: $id, nombre: $nombre, apellidos: $apellidos, telefono: $telefono, correo: $correo, sexo: $sexo, edad: $edad, direccion: $direccion, direccionNumero: $direccionNumero, colonia: $colonia, nacionalidad: $nacionalidad, ocupacion: $ocupacion}';
  }
}
