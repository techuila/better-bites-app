import 'dart:convert';
import 'package:betterbitees/services/DTOs/food_analysis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodAiService {
  static const String _baseUrl = 'better-bites-be.onrender.com';

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
        final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
        debugPrint('Food analysis response: $prettyJson');
        return FoodAnalysisResponse.fromJson(data);
      } else if (response.statusCode == 500) {
        debugPrint('Failed to analyze food: ${response.body}');
        throw jsonDecode(response.body);
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to analyze food: $e');
      throw Exception('Failed to analyze food: $e');
    }
  }

  Future<void> analyzeFood(BuildContext context, String ingredients,
      void Function(FoodAnalysisResponse) callback) async {
    final payload = {'ingredients': ingredients};

    try {
      final foodAnalysisResponse = await _requestToAnalyzeFood(payload);

      callback(foodAnalysisResponse);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing food: $e')),
        );
      }
    }
  }
}
