import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videodown/data/model/download.model.dart';

import 'dart:async';
import 'dart:io';



class DownloadDatabase{
  static final DownloadDatabase _instance = DownloadDatabase._internal();

  factory DownloadDatabase() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if(_db != null){
      return _db!;
    }

    _db = await initDB();
    return _db!;
  }

  DownloadDatabase._internal();

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "DemoAppDownloadspf.db");
    print("dheerpath: $documentDirectory.$path");
    var theDB = await openDatabase(path,version: 1,onCreate: _onCreate);
    return theDB;
  }

  void _onCreate(Database db,int version) async{
    await db.execute("CREATE TABLE Downloads(id STRING PRIMARY KEY, videoname TEXT, videourl TEXT, imageurl TEXT, localurl TEXT, localname TEXT, downloadertype TEXT, headers TEXT, ex1 TEXT, ex2 TEXT, extra TEXT, isgrabbed BIT, iscompleted BIT)");

    print("Database was Created!");
  }

  Future<List<DownloadEpisodelist>> getMovies() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Downloads");
    return res.map((m) => DownloadEpisodelist.fromDb(m)).toList();
  }

  Future<DownloadEpisodelist> getMovie(String id) async { 
    var dbClient = await db;
    var res = await dbClient.query("Downloads", where: "videoname = ?", whereArgs: [id]);
    // if (res.length == 0) return null;
    return DownloadEpisodelist.fromDb(res[0]);
  }

  Future<int> addMovie(DownloadEpisodelist movie) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Downloads", movie.toMap());
      print("Movie added $res");
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> updateMovie(DownloadEpisodelist movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Downloads", movie.toMap(),where: "videoname = ?", whereArgs: [movie.videoname]);
    print("Movie updated $res");
    return res;
  }

  Future<int> setIsCompleted(DownloadEpisodelist movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Downloads", movie.toMap() ,where: "iscompleted = ?", whereArgs: [true]);
    print("Movie setIsCompleted $res");
    print("Movie setIsCompletedsdsdsdsdsdsds:; ${movie.iscompleted}");

    return res;
  }

  Future<int> changeVideoName(DownloadEpisodelist movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Downloads", movie.toMap(),where: "videoname = ?", whereArgs: [movie.videoname]);
    print("Movie changeVideoName $res");
    return res;
  }

  Future<int> deleteMovie(String id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Downloads", where: "videoname = ?", whereArgs: [id]);
    print("Movie deleted $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}