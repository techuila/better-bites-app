import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> open() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'food_analysis.db'),
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute(
            'CREATE TABLE food_analysis(id INTEGER PRIMARY KEY, title TEXT, image_path TEXT, recognized_text TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);');
        batch.execute(
            'CREATE TABLE suitable_ingredients(id INTEGER PRIMARY KEY, food_analysis_id INTEGER, name TEXT, description TEXT);');
        batch.execute(
            'CREATE TABLE unsuitable_ingredients(id INTEGER PRIMARY KEY, food_analysis_id INTEGER, name TEXT, description TEXT);');
        batch.execute(
            'CREATE TABLE health_tips(id INTEGER PRIMARY KEY, food_analysis_id INTEGER, name TEXT, description TEXT);');
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion != newVersion) {
          Batch batch = db.batch();
          batch.execute('DROP TABLE IF EXISTS food_analysis;');
          batch.execute('DROP TABLE IF EXISTS suitable_ingredients;');
          batch.execute('DROP TABLE IF EXISTS unsuitable_ingredients;');
          batch.execute('DROP TABLE IF EXISTS health_tips;');
          await batch.commit();
        }
      },
      version: 2,
    );
  }
}
