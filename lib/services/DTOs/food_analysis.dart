class FoodAnalysisResponse {
  final List<String> suggestedIngredients;
  final String explanation;
  final String healthRisks;

  FoodAnalysisResponse({
    required this.suggestedIngredients,
    required this.explanation,
    required this.healthRisks,
  });

  factory FoodAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResponse(
      suggestedIngredients:
          List<String>.from(json['suggested_ingredients'] ?? []),
      explanation: json['explanation'] ?? '',
      healthRisks: json['health_risks'] ?? '',
    );
  }
}
