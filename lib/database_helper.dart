import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  static const String tableGifts = 'gifts';

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'gifts.db');
    return await openDatabase(
      path,
      version: 3, // 更新版本號
      onCreate: (db, version) async {
        await _createGiftsTable(db);
        await _insertDefaultGifts(db); // 插入預設數據
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE $tableGifts ADD COLUMN isDefault INTEGER DEFAULT 0");
          await _insertDefaultGifts(db);
        }
      },
    );
  }

  Future<void> _createGiftsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableGifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT,
        name TEXT,
        type TEXT,
        price TEXT,
        link TEXT,
        isDefault INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _insertDefaultGifts(Database db) async {
    // 首先檢查是否已經插入了預設數據
    final existingGifts = await db.query(
      tableGifts,
      where: 'isDefault = ?',
      whereArgs: [1],
    );

    if (existingGifts.isNotEmpty) {
      // 如果預設數據已存在，不再插入
      return;
    }

    // 插入預設數據
    final defaultGifts = [
      {
        "image": "assets/watch.png",
        "name": "Apple Watch 5",
        "type": "Smart watch",
        "price": "\$299.00",
        "link": "https://www.apple.com/watch/",
        "isDefault": 1,
      },
      {
        "image": "assets/game.png",
        "name": "Gaming Console",
        "type": "Gaming",
        "price": "\$499.00",
        "link": "https://www.playstation.com/",
        "isDefault": 1,
      },
      {
        "image": "assets/phone.png",
        "name": "Smartphone",
        "type": "Mobile",
        "price": "\$799.00",
        "link": "https://www.samsung.com/",
        "isDefault": 1,
      },
      {
        "image": "assets/shoes.png",
        "name": "Sneakers",
        "type": "Fashion",
        "price": "\$89.00",
        "link": "https://www.nike.com/",
        "isDefault": 1,
      },
      {
        "image": "assets/speakers.png",
        "name": "Bluetooth Speaker",
        "type": "Audio",
        "price": "\$199.00",
        "link": "https://www.jbl.com/",
        "isDefault": 1,
      },
    ];

    for (var gift in defaultGifts) {
      await db.insert(tableGifts, gift);
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllGifts() async {
    return await (await database).query(tableGifts);
  }

  Future<int> insertGift(Map<String, dynamic> gift) async {
    return await (await database).insert(tableGifts, gift);
  }

  Future<int> deleteGift(int id) async {
    try {
      final db = await database;
      await db
          .rawDelete("DELETE FROM sqlite_sequence WHERE name = '$tableGifts'");
      return await db.delete(
        tableGifts,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting from table $tableGifts: $e");
      return -1;
    }
  }


  Future<int> updateGift(int id, Map<String, dynamic> gift) async {
    return await (await database).update(
      tableGifts,
      gift,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(tableGifts);
  }

}