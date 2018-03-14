import 'dart:async';

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloodpit/report.dart';

Future<bool> addReport(Report report) async {
  Database db = await getDB();
  final int resId = await db.insert("Reports", report.toMap());
  if (resId == 0) {
    return false;
  }
  return true;
}

Future<Database> getDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "assets_bloodpit.db");

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Reports (id INTEGER PRIMARY KEY AUTOINCREMENT, date INTEGER, timing INTEGER, first_min INTEGER, first_max INTEGER, first_pul INTEGER, second_min INTEGER, second_max INTEGER, second_pul INTEGER)");
  });
  return database;
}
