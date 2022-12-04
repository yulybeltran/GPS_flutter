import 'package:geolocator/geolocator.dart';
import "package:sqflite/sqflite.dart" as sql;

class peticionesBD {
  //////////////////////77
  static Future<void> crearTabla(sql.Database database) async {
    await database.execute(""" CREATE TABLE posicion(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      coordenadas TEXT,
      fechahora TEXT
     
      ) """);
  }

///////////////////////////////////////////
  static Future<sql.Database> db() async {
    return sql.openDatabase('minticgps.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await crearTabla(database);
    });
  }

/////////////////////////////////////
  static Future<void> guardarPocision(coor, feho) async {
    final db = await peticionesBD.db();

    final datos = {"coordenadas": coor, "fechahora": feho};

    await db.insert("posicion", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

///////////////////////////////
  static Future<List<Map<String, dynamic>>> ListarTodasPocisiones() async {
    final db = await peticionesBD.db();
    return db.query("posicion", orderBy: "fechahora");
  }

///////////////////////////
  static Future<void> EliminarPosicion(int id) async {
    final db = await peticionesBD.db();
    await db.delete("posicion", where: "id=?", whereArgs: [id]);
  }

///////////////////////////
  static Future<void> EliminarTodos() async {
    final db = await peticionesBD.db();
    await db.delete("posicion");
  }
  //////////////////////

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('El GPS Esta desabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso Denegado');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permiso denegado permanentemente...');
    }

    return await Geolocator.getCurrentPosition();
  }
}
