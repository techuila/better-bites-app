class FoodAnalysis {
  int? id;
  String? imagePath;
  String? recognizedText;
  final String title;
  final List<Item> suitableIngredients;
  final List<Item> unsuitableIngredients;
  final List<Item> healthTips;

  FoodAnalysis({
    this.id,
    this.imagePath,
    this.recognizedText,
    required this.title,
    required this.suitableIngredients,
    required this.unsuitableIngredients,
    required this.healthTips,
  });

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    return FoodAnalysis(
      id: json['id'] ?? -1,
      imagePath: json['image_path'] ?? '',
      recognizedText: json['recognized_text'] ?? '',
      title: json['title'],
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

  factory FoodAnalysis.toJson(Map<String, dynamic> json) {
    return FoodAnalysis(
      id: json['id'] ?? -1,
      imagePath: json['image_path'] ?? '',
      recognizedText: json['recognized_text'] ?? '',
      title: json['title'] ?? '',
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
