import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filme.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'filmes.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filmes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        ano INTEGER NOT NULL,
        direcao TEXT NOT NULL,
        resumo TEXT NOT NULL,
        urlCartaz TEXT NOT NULL,
        nota REAL NOT NULL
      )
    ''');
  }

  Future<int> insertFilme(Filme filme) async {
    final db = await database;
    return await db.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> getFilmes() async {
    final db = await database;
    final result = await db.query('filmes');
    return result.map((map) => Filme.fromMap(map)).toList();
  }

  Future<int> updateFilme(Filme filme) async {
    final db = await database;
    return await db.update('filmes', filme.toMap(), where: 'id = ?', whereArgs: [filme.id]);
  }

  Future<int> deleteFilme(int id) async {
    final db = await database;
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }
}
