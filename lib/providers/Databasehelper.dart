//import 'package:sqflite/sqflite.dart';
import 'package:noteapp/models/note.dart';
import 'package:secure_random/secure_random.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  static final _databaseName = "notesdb3.db"; //notesdb.db
  static final _databaseVersion = 1;

  static final table = 'notes';

  static final columnId = 'id';
  static final columnTitle = 'title';

  //static final d1 = Crypt.sha512('password');

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    if (firststart = true) {
      _getPasswordFromSharedPref();
      _hashing();
      _addNewItem();
      _read();
      firststart = false;
      String path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(path,
          password: '$value', version: _databaseVersion, onCreate: _onCreate);
    } else {
      _read();
      String path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(path,
          password: '$value', version: _databaseVersion, onCreate: _onCreate);
    }
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

  ///
  /// Password do bazy danych
  ///
  bool firststart = true;

  String d1 = ('');
  String value = '';

  final _storage = FlutterSecureStorage();

  void _addNewItem() async {
    final String key = 'smth';
    final String value = d1;

    await _storage.write(key: key, value: value);
  }

  Future<String> _read() async {
    String value = await _storage.read(key: 'smth');
    return value;
  }

  Future<String> _getPasswordFromSharedPref() async {
    var secureRandom = SecureRandom();
    d1 = (secureRandom.nextString(
        length: 20,
        charset:
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#\$%^&*()_+`'));
    print('password recived : $d1');
    return d1;
  }

  void _hashing() async {
    final hashed = Crypt.sha512(d1);
    String hashed2 = hashed.toString();
    d1 = hashed2;
    print('password hashed in ss $d1');
  }
}
