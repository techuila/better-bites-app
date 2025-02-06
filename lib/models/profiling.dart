class Profiling {
  int? id;
  String age;
  String gender;
  String height;
  String weight;
  String healthCondition;

  Profiling({
    this.id,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.healthCondition
  });

  factory Profiling.toJson(Map<String, Object?> json) {
    return Profiling(
      id: int.parse(json['id'].toString()) ?? -1,
      age: json['age'].toString() ?? '',
      gender: json['gender'].toString() ?? '',
      height: json['height'].toString() ?? '',
      weight: json['weight'].toString() ?? '',
      healthCondition: json['health_condition'].toString(),
    );
  }
}