import 'dart:convert';
import 'dart:io';
import 'package:betterbitees/helpers/file_storage.dart';
import 'package:betterbitees/models/food_analysis.dart';
import 'package:betterbitees/repositories/food_analysis_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodAnalysisService {
  //static const String _baseUrl = '10.0.2.2:3000'; // for local testing
  static const String _baseUrl = 'better-bites-be.onrender.com';
  final FoodAnalysisRepo foodAnalysisRepo;

  FoodAnalysisService({required this.foodAnalysisRepo});

  // create private function
  Future<FoodAnalysis> _requestToAnalyzeFood(
      Map<String, dynamic> requestBody) async {
    final url = Uri.https(_baseUrl, 'analyze');
    try {
      debugPrint('Requesting food analysis from $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['error'] != null) {
          throw data['error'];
        }

        final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
        debugPrint('Food analysis response: $prettyJson');
        return FoodAnalysis.fromJson(data);
      } else if (response.statusCode == 500) {
        debugPrint('Internal Server Error: ${response.body}');
        throw 'Server Error: Encountered an error while processing the request';
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        throw 'Unexpected status code: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Failed to analyze food: $e');
      throw 'Failed to analyze food: $e';
    }
  }

  Future<FoodAnalysis> _saveFoodAnalysis(
      FoodAnalysis foodAnalysis, String ingredients, File image) async {
    final savedFileName = await FileStorageHelper.saveFile(image);

    foodAnalysis.imagePath = savedFileName;
    foodAnalysis.recognizedText = ingredients;

    final foodAnalysisId = await foodAnalysisRepo.create(foodAnalysis);
    debugPrint('Saved food analysis with ID: $foodAnalysisId');

    foodAnalysis.id = foodAnalysisId;

    return foodAnalysis;
  }

  Future<void> analyzeFood(String ingredients, File image,
      void Function(FoodAnalysis) callback) async {
    final payload = {'ingredients': ingredients};

    final foodAnalysisResponse = await _requestToAnalyzeFood(payload);
    final foodAnalysis =
        await _saveFoodAnalysis(foodAnalysisResponse, ingredients, image);

    callback(foodAnalysis);
  }

  Future<List<Future<FoodAnalysis>>> getAll() async {
    return await foodAnalysisRepo.getAll();
  }
}
