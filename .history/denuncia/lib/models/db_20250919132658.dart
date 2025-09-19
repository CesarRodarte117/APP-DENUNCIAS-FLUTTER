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
            usuarioIdentificador TEXT,
            estatus TEXT,
            clave TEXT,
            nombre TEXT,
            apellidoPaterno TEXT,
            apellidoMaterno TEXT,
            telefono TEXT,
            correo TEXT,
            sexo TEXT,
            edad TEXT,
            direccion TEXT,
            direccionNumero TEXT,
            colonia TEXT,
            nacionalidad TEXT,
            numeroIdentificacion TEXT,
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
    return await db.insert(
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
    print('🔴 Evidencias obtenidas: ${maps.length}');
    return List.generate(maps.length, (i) => Evidencia.fromMap(maps[i]));
  }

  Future<void> updateDenunciaStatus(String clave, String nuevoEstatus) async {
    // 1. Obtenemos la instancia de la base de datos.
    final db = await database;

    // 2. Usamos el método `update` de sqflite.
    final rowsAffected = await db.update(
      'denuncia', // Nombre de la tabla.
      {'estatus': nuevoEstatus}, // Mapa con los valores a actualizar.
      where: 'clave = ?', // Condición para encontrar el registro correcto.
      whereArgs: [clave], // Argumentos para la condición WHERE.
    );

    // (Opcional) Imprimimos un log para saber si la actualización funcionó.
    if (rowsAffected > 0) {
      print('✅ Estatus actualizado para la clave: $clave');
    } else {
      print(
        '⚠️ No se encontró ninguna denuncia con la clave: $clave para actualizar.',
      );
    }
  }

  Future<void> updateDenuncia(Denuncia denuncia) async {
    final db = await database;
    await db.update(
      'denuncia',
      denuncia.toMap(), // Envía el objeto completo para actualizar
      where: 'id = ?', // La busca por su ID local
      whereArgs: [denuncia.id],
    );
    print('✅ Denuncia con id ${denuncia.id} actualizada en la BD local.');
  }

Future<void> actualizarClaveManualmente(int id, String nuevaClave) async {
  final db = await database;

  // Busca la denuncia por su ID local y le asigna la nueva clave.
  final rowsAffected = await db.update(
    'denuncia',
    {'clave': nuevaClave.trim()}, // Le asignamos la nueva clave (y la limpiamos por si acaso)
    where: 'id = ?',           // La condición es el ID local
    whereArgs: [id],
  );

  if (rowsAffected > 0) {
    print('✅ Clave actualizada para el ID local $id: $nuevaClave');
  } else {
    print('⚠️ No se encontró ninguna denuncia con el ID local $id para actualizar.');
  }
}
