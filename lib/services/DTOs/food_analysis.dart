class FoodAnalysisResponse {
  final List<Item> suitableIngredients;
  final List<Item> unsuitableIngredients;
  final List<Item> healthTips;

  FoodAnalysisResponse({
    required this.suitableIngredients,
    required this.unsuitableIngredients,
    required this.healthTips,
  });

  factory FoodAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResponse(
      suitableIngredients: (json['suitable_ingredients'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
      unsuitableIngredients: (json['unsuitable_ingredients'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
      healthTips: (json['health_tips'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

class Item {
  final String name;
  final String description;

  Item({
    required this.name,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
