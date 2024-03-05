import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'bookmarks';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bookmark_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            title TEXT,
            company TEXT,
            companyLocation TEXT,
            logo TEXT,
            salary TEXT,
            jobPosted TEXT,
            jobType TEXT,
            button1Title TEXT,
            button1Href TEXT,
            button2Title TEXT,
            button2Href TEXT,
            jobDescription TEXT
          )
          ''',
        );
      },
    );
  }
  static Future<void> insertBookmark(SearchQueryResponseData bookmark) async {
    final db = await database;

    // Convert bookmark data to a map
    final Map<String, dynamic> bookmarkMap = bookmark.toJson();

    try {
      // Check if a bookmark with the same title and company already exists
      final existingBookmarks = await db.query(
        _tableName,
        where: 'title = ? AND company = ?',
        whereArgs: [bookmark.title, bookmark.company],
      );

      if (existingBookmarks.isNotEmpty) {
        // If the bookmark already exists, update it
        await db.update(
          _tableName,
          bookmarkMap,
          where: 'title = ? AND company = ?',
          whereArgs: [bookmark.title, bookmark.company],
        );
      } else {
        // If the bookmark does not exist, insert it
        await db.insert(
          _tableName,
          bookmarkMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('Error inserting/updating bookmark: $e');
    }
  }


  // static Future<void> insertBookmark(SearchQueryResponseData bookmark) async {
  //   final db = await database;
  //   await db.insert(
  //     _tableName,
  //     bookmark.toJson(),
  // //    conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  static Future<List<SearchQueryResponseData>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return SearchQueryResponseData(
        id: maps[i]['id'] ,
        title: maps[i]['title'],
        company: maps[i]['company'],
        companyLocation: maps[i]['companyLocation'],
        logo: maps[i]['logo'],
        salary: maps[i]['salary'],
        jobPosted: maps[i]['jobPosted'],
        jobType: maps[i]['jobType'],
        button1Title: maps[i]['button1Title'],
        button1Href: maps[i]['button1Href'],
        button2Title: maps[i]['button2Title'],
        button2Href: maps[i]['button2Href'],
        jobDescription: maps[i]['jobDescription'],
      );
    });
  }

  static Future<bool> isBookmarked(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  static Future<void> deleteBookmark(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
