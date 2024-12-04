import 'dart:convert';
import 'package:betterbitees/services/DTOs/food_analysis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodAiService {
  static const String _baseUrl = 'better-bites-be.onrender.com';
  //static const String _baseUrl = '10.0.2.2:3000'; // for local testing

  // create private function
  Future<FoodAnalysisResponse> _requestToAnalyzeFood(
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
        return FoodAnalysisResponse.fromJson(data);
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

  Future<void> analyzeFood(
      String ingredients, void Function(FoodAnalysisResponse) callback) async {
    final payload = {'ingredients': ingredients};

    final foodAnalysisResponse = await _requestToAnalyzeFood(payload);

    callback(foodAnalysisResponse);
  }
}
