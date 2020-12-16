//import 'package:sqflite/sqflite.dart';
import 'package:noteapp/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "notestest5.db";
  static final _databaseVersion = 1;

  static final table = 'notes';

  static final columnId = 'id';
  static final columnTitle = 'title';

  //static final d1 = Crypt.sha512('password');
  static final d1 = ('password');

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        password: '$d1', version: _databaseVersion, onCreate: _onCreate);
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL)
    ''');
  }

  Future<int> insert(Note note) async {
    Database db = await instance.database;
    var res = await db.insert(table, note.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId ASC");
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}
