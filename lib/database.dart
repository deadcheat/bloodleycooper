import 'dart:async';

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloodpit/report.dart';

Database db;

Future close() async => db.close();

Future<Report> addReport(Report report) async {
  db = await getDB();
  final int resId = await db.insert("Reports", report.toMap());
  if (resId == 0) {
    return null;
  }
  return new Report(
      resId, report.day, report.timing, report.first, report.second);
}

Future<Map<int, List<Report>>> findReports(int year, int month) async {
  db = await getDB();
  List<Map> reports =
      await db.query("Reports", where: "$year = ? and $year = ?");
  return Report.fromMap(reports);
}

Future<Database> getDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "assets_bloodpit.db");

  db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Reports (id INTEGER PRIMARY KEY AUTOINCREMENT, date INTEGER, year INTEGER, month INTEGER, day INTEGER, timing INTEGER, first_min INTEGER, first_max INTEGER, first_pul INTEGER, second_min INTEGER, second_max INTEGER, second_pul INTEGER)");
  });
  return db;
}
