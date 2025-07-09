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
            ocupacion TEXT,
            servidorNombre TEXT,
            servidorCargo TEXT,
            servidorDependencia TEXT,
            servidorIdentificacionDetalle TEXT,
            servidorEcho TEXT,
            servidorDistrito TEXT,
            servidorDireccion TEXT,
            servidorDireccionCalles TEXT,
            servidorColonia TEXT,
            servidorEvidencia TEXT,
            servidorMotivo TEXT,
            servidorFechaOcurrido TEXT,
            fecha TEXT,
            hora TEXT)
        ''');

        // Nueva tabla para evidencias
        await db.execute('''
          CREATE TABLE evidencias(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denuncia_id INTEGER,
            url TEXT,
            path_local TEXT,
            tipo TEXT,
            nombre_archivo TEXT,
            FOREIGN KEY (denuncia_id) REFERENCES denuncia(id)
          )
        ''');
      },
      version: 2,
    );
  }

  Future<int> insertDenuncia(Denuncia denuncia) async {
    final Database db = await database;
    await db.insert(
      'denuncia',
      denuncia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Denuncia>> getAllDenuncias() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('denuncia');
    return List.generate(maps.length, (i) {
      return Denuncia.fromMap(maps[i]);
    });
  }

  Future<int> insertEvidencia(Evidencia evidencia) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'evidencias',
      evidencia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Evidencia>> getEvidenciasPorDenuncia(int denunciaId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'evidencias',
      where: 'denuncia_id = ?',
      whereArgs: [denunciaId],
    );
    return List.generate(maps.length, (i) => Evidencia.fromMap(maps[i]));
  }
}
