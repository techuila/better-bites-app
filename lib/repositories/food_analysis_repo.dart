import 'package:betterbitees/helpers/db.dart';
import 'package:betterbitees/models/food_analysis.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class FoodAnalysisRepo {
  Future<FoodAnalysis> getFoodAnalysis(String foodId) async {
    final db = await DBHelper.open();
    final food =
        await db.query('food_analysis', where: 'id = ?', whereArgs: [foodId]);

    if (food.isEmpty) {
      throw Exception('Food not found');
    }

    final suitableIngredients = await db.query('suitable_ingredients',
        where: 'id = ?', whereArgs: [food.first['id']]);

    final unsuitableIngredients = await db.query('unsuitable_ingredients',
        where: 'id = ?', whereArgs: [food.first['id']]);

    final healthTips = await db
        .query('health_tips', where: 'id = ?', whereArgs: [food.first['id']]);

    return FoodAnalysis.fromJson({
      'id': food.first['id'],
      'title': food.first['title'],
      'image_path': food.first['image_path'],
      'suitable_ingredients': suitableIngredients,
      'unsuitable_ingredients': unsuitableIngredients,
      'health_tips': healthTips
    });
  }

  Future<int> create(FoodAnalysis food) async {
    final db = await DBHelper.open();
    Batch batch = db.batch();

    debugPrint('Creating food analysis: $food');

    final foodAnalysisId = await db.insert('food_analysis', {
      'title': food.title,
      'image_path': food.imagePath,
      'recognized_text': food.recognizedText
    });

    for (final item in food.suitableIngredients) {
      batch.insert('suitable_ingredients', {
        'food_analysis_id': foodAnalysisId,
        'name': item.name,
        'description': item.description
      });
    }

    for (final item in food.unsuitableIngredients) {
      batch.insert('unsuitable_ingredients', {
        'food_analysis_id': foodAnalysisId,
        'name': item.name,
        'description': item.description
      });
    }

    for (final item in food.healthTips) {
      batch.insert('health_tips', {
        'food_analysis_id': foodAnalysisId,
        'name': item.name,
        'description': item.description
      });
    }

    await batch.commit(noResult: true);

    return foodAnalysisId;
  }
}
