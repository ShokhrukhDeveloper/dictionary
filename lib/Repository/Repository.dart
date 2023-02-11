import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'package:dictionary/Entities/Word.dart';

class Repository {
  static const String _dbPath = "assets/Dictionary.db";
  static Future<Database> init() async {
    if (_database == null) await initDb();
    return _database!;
  }

  static Future<void> initDb() async {
    //get path
    var databasesPath = await getDatabasesPath();
    // join path database name
    var path = join(databasesPath, "Dictionary.db");
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      debugPrint("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      var data = await rootBundle.load(join("assets", "Dictionary.db"));
      // print(data.elementSizeInBytes);
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("Opening existing database");
    }
    _database = await openDatabase(path, readOnly: true);
  }

  static Database? _database;
  static Future<List<Word>> getResult(String text,
      {int limit = 40, int page = 1}) async {
    var db = await init();
    var query = await db.query("entries",
        columns: ["word", "wordtype"],
        where: "Word LIKE ?",
        whereArgs: ["%$text"],
        limit: limit,
        orderBy: "Word DESC",
        offset: limit * (page - 1));
    final jsonList = query.map((item) => jsonEncode(item)).toList();
    var myset = jsonList.toSet().toList();
    final result = myset.map((item) => jsonDecode(item)).toList();
    var words = result.map((e) => Word.json(e)).toList();
    return words;
  }

  static Future<List<Word>> getWordMeans({required String text}) async {
    var db = await init();
    // text=;
    var query = await db.query(
      "entries",
      where: "Word = ?",
      whereArgs: [text[0].toLowerCase() + text.substring(1)],
    );
    var words = query.map((e) => Word.json(e)).toList();
    return words;
  }

  static Future<List<Word>> getInitial({int limit = 40, int page = 1}) async {
    var db = await init();
    var query = await db.query("entries",
        columns: ["word", "wordtype"],
        limit: limit,
        offset: limit * (page - 1));
    final jsonList = query.map((item) => jsonEncode(item)).toList();
    var myset = jsonList.toSet().toList();
    final result = myset.map((item) => jsonDecode(item)).toList();
    var words = result.map((e) => Word.json(e)).toList();
    return words;
  }
}
