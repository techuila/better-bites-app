import 'package:betterbitees/helpers/db.dart';
import 'package:betterbitees/models/food_analysis.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class FoodAnalysisRepo {
  Future<List<Future<FoodAnalysis>>> getAll() async {
    final db = await DBHelper.open();
    final foods = await db.query('food_analysis');

    final foodList = foods.map((food) async {
      final suitableIngredients = await _getSuitableIngredients(food['id'] as String);
      final unsuitableIngredients = await _getUnsuitableIngredients(food['id'] as String);
      final healthTips = await _getHealthTips(food['id'] as String);

      return FoodAnalysis.fromJson({
        ...food,
        'suitable_ingredients': suitableIngredients,
        'unsuitable_ingredients': unsuitableIngredients,
        'health_tips': healthTips
      });
    }).toList();

    return foodList;
  }

  Future<FoodAnalysis> getFoodAnalysis(String foodId) async {
    final db = await DBHelper.open();
    final food =
        await db.query('food_analysis', where: 'id = ?', whereArgs: [foodId]);

    if (food.isEmpty) {
      throw Exception('Food not found');
    }

    final suitableIngredients = await _getSuitableIngredients(foodId);
    final unsuitableIngredients = await _getUnsuitableIngredients(foodId);
    final healthTips = await _getHealthTips(foodId);

    return FoodAnalysis.fromJson({
      'id': food.first['id'],
      'title': food.first['title'],
      'image_path': food.first['image_path'],
      'suitable_ingredients': suitableIngredients,
      'unsuitable_ingredients': unsuitableIngredients,
      'health_tips': healthTips
    });
  }

  Future<dynamic> _getSuitableIngredients(String foodId) async {
    final db = await DBHelper.open();
    final ingredients = await db.query('suitable_ingredients',
        where: 'food_analysis_id = ?', whereArgs: [foodId]);

    return ingredients;
  }

  Future<dynamic> _getUnsuitableIngredients(String foodId) async {
    final db = await DBHelper.open();
    final ingredients = await db.query('unsuitable_ingredients',
        where: 'food_analysis_id = ?', whereArgs: [foodId]);

    return ingredients;
  }

  Future<dynamic> _getHealthTips(String foodId) async {
    final db = await DBHelper.open();
    final tips = await db.query('health_tips',
        where: 'food_analysis_id = ?', whereArgs: [foodId]);

    return tips;
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
