import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'denuncia.dart';
export 'db.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'denuncia.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE denuncia(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            apellidos TEXT,
            telefono TEXT,
            correo TEXT,
            sexo TEXT,
            edad TEXT,
            direccion TEXT,
            direccionNumero TEXT,
            colonia TEXT,
            nacionalidad TEXT,
            ocupacion TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertDenuncia(Denuncia denuncia) async {
    final Database db = await database;
    await db.insert(
      'denuncia',
      denuncia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
