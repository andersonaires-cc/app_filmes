import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_filmes/models/filme.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meus_filmes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE filmes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT,
      ano INTEGER,
      direcao TEXT,
      resumo TEXT,
      url_cartaz TEXT,
      nota REAL
    )
    ''');
  }

  Future<int> insertFilme(Filme filme) async {
    final db = await instance.database;
    return await db.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> getAllFilmes() async {
    final db = await instance.database;
    final result = await db.query('filmes');
    return result.map((json) => Filme.fromMap(json)).toList();
  }

  Future<int> updateFilme(Filme filme) async {
    final db = await instance.database;
    return await db.update(
      'filmes',
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<int> deleteFilme(int id) async {
    final db = await instance.database;
    return await db.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
