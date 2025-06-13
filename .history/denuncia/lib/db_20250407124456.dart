import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'denuncia.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE denuncia(id INTEGER PRIMARY KEY, nombre TEXT, apellidos TEXT, telefono TEXT, correo TEXT, sexo TEXT, edad TEXT, direccion TEXT, direccionNumero TEXT, colonia TEXT, nacionalidad TEXT, ocupacion TEXT)',
      );
    },
    version: 1,
  );
}
