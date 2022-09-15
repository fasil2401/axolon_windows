import 'dart:io';

import 'package:axolon_container/model/connection_setting_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final _databaseName = 'axolon.db';
  final _databaseVersion = 1;
  final _newVersion = 2;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    final applicationPath = await getDatabaseApplicationPath();
    final path = join(applicationPath, _databaseName);
    return await openDatabase(path,
        version: _newVersion,
        onCreate: (db, version) => _onCreate(db),
        onUpgrade: _onUpgrade);
  }

  getDatabaseApplicationPath() async {
    Directory? applicationPath = await getApplicationDocumentsDirectory();
    return applicationPath.path;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (_newVersion > _databaseVersion) {
      db.execute('''ALTER TABLE ${ConnectionModelImpNames.tableName}
          ADD COLUMN ${ConnectionModelImpNames.userName} DOUBLE          
          ''');
      db.execute('''ALTER TABLE ${ConnectionModelImpNames.tableName}
          ADD COLUMN ${ConnectionModelImpNames.password} TEXT       
          ''');
    }
  }

  _onCreate(Database db) async {
    await db.execute('''
    CREATE TABLE ${ConnectionModelImpNames.tableName}(
        ${ConnectionModelImpNames.connectionName} TEXT,
       ${ConnectionModelImpNames.serverIp} TEXT,
        ${ConnectionModelImpNames.webPort} TEXT,
        ${ConnectionModelImpNames.httpPort} TEXT,
        ${ConnectionModelImpNames.erpPort} TEXT,
        ${ConnectionModelImpNames.databaseName} TEXT,
        ${ConnectionModelImpNames.userName} TEXT,
        ${ConnectionModelImpNames.password} TEXT
    )
    ''');
  }

  Future<int> insertSettings(ConnectionModel setting) async {
    Database? db = await DbHelper._database;
    return await db!.insert(ConnectionModelImpNames.tableName, {
      ConnectionModelImpNames.connectionName: setting.connectionName,
      ConnectionModelImpNames.serverIp: setting.serverIp,
      ConnectionModelImpNames.webPort: setting.webPort,
      ConnectionModelImpNames.httpPort: setting.httpPort,
      ConnectionModelImpNames.erpPort: setting.erpPort,
      ConnectionModelImpNames.databaseName: setting.databaseName,
      ConnectionModelImpNames.userName: setting.userName,
      ConnectionModelImpNames.password: setting.password
    });
  }

  Future<List<Map<String, dynamic>>> queryAllSettings() async {
    Database? db = await DbHelper._database;
    return await db!.query(ConnectionModelImpNames.tableName);
  }

  Future<int> updateConnectionSettings(
      String connectionName, String userName, String password) async {
    Database? db = await DbHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ConnectionModelImpNames.tableName}
    SET ${ConnectionModelImpNames.userName} = ?, ${ConnectionModelImpNames.password} = ?
    WHERE ${ConnectionModelImpNames.connectionName} = ?
    ''', [userName, password, connectionName]);
  }

  Future<int> updateFields({
    required String connectionName,
    required String serverIp,
    required String webPort,
    required String httpPort,
    required String erpPort,
    required String databaseName,
  }) async {
    Database? db = await DbHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ConnectionModelImpNames.tableName}
    SET ${ConnectionModelImpNames.serverIp} = ?, 
    ${ConnectionModelImpNames.webPort} = ?, 
    ${ConnectionModelImpNames.httpPort} = ?, 
    ${ConnectionModelImpNames.erpPort} = ?, 
    ${ConnectionModelImpNames.databaseName} = ?
    WHERE ${ConnectionModelImpNames.connectionName} = ?
    ''', [serverIp, webPort, httpPort, erpPort, databaseName, connectionName]);
  }

  deleteSettingsTable() async {
    Database? db = await DbHelper._database;
    await db!.delete(ConnectionModelImpNames.tableName);
  }
}
