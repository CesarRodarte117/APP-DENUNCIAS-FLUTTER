import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import denuncia.dart';

// database_helper.dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<void> insertDenuncia(Denuncia denuncia) async {
    final Database db = await database;
    await db.insert(
      'denuncia',
      denuncia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obtener todas las denuncias
  Future<List<Denuncia>> denuncias() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('denuncia');
    return List.generate(maps.length, (i) {
      return Denuncia(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        apellidos: maps[i]['apellidos'],
        sexo: maps[i]['sexo'],
        edad: maps[i]['edad'],
        telefono: maps[i]['telefono'],
        direccion: maps[i]['direccion'],
        direccionNumero: maps[i]['direccionNumero'],
        colonia: maps[i]['colonia'],
        correo: maps[i]['correo'],
        ocupacion: maps[i]['ocupacion'],
        nacionalidad: maps[i]['nacionalidad'],
      );
    });
  }
}