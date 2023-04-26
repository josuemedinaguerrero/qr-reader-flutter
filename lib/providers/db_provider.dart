import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:qr_reader/models/scan_model.dart' as scan_model;
import 'package:sqflite/sqflite.dart' as sqflite;

class DBProvider {
  static sqflite.Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<sqflite.Database> initDB() async {
    Directory documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'ScansDB.db');
    print('path: $path');

    return await sqflite.openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (sqflite.Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

  Future<int> nuevoScan(scan_model.ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());
    print('res $res');

    return res;
  }

  Future<scan_model.ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? scan_model.ScanModel.fromJson(res.first) : null;
  }

  Future<List<scan_model.ScanModel>?> getTodosLosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((s) => scan_model.ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<scan_model.ScanModel>?> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");

    return res.isNotEmpty ? res.map((s) => scan_model.ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(scan_model.ScanModel nuevoScan) async {
    final db = await database;
    final res =
        await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);

    print('Res UPDATE: $res');
    return res;
  }

  Future<int> deleteScans(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
