import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../quote.dart';

const String fileName = "quote_database.db";
const String tableName = "quotes";

const String idField = "id";
const String textField = "text";
const String authorField = "author";

class AppDatabase {
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future<Database> _initializeDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    print('Database path: $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idField INTEGER PRIMARY KEY AUTOINCREMENT,
        $textField TEXT NOT NULL,
        $authorField TEXT NOT NULL
      )
    ''');
  }

  Future<Quote> createQuote(Quote quote) async {
    final db = await instance.database;
    final id = await db.insert(tableName, quote.toMap());
    print('Inserted quote with id: $id');
    return quote.copyWith(id: id);
  }

  Future<List<Quote>> readAllQuotes() async {
    final db = await instance.database;
    final result = await db.query(tableName, orderBy: '$idField DESC');
    print('Fetched quotes: $result');
    return result.map((json) => Quote.fromMap(json)).toList();
  }

  Future<int> updateQuote(Quote quote) async {
    final db = await instance.database;
    final rowsUpdated = await db.update(
      tableName,
      quote.toMap(),
      where: '$idField = ?',
      whereArgs: [quote.id],
    );
    print('Updated $rowsUpdated row(s)');
    return rowsUpdated;
  }

  Future<int> deleteQuote(int id) async {
    final db = await instance.database;
    final rowsDeleted = await db.delete(
      tableName,
      where: '$idField = ?',
      whereArgs: [id],
    );
    print('Deleted $rowsDeleted row(s)');
    return rowsDeleted;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}