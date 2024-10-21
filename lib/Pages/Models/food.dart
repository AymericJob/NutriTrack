class Food {
  final String name;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;

  Food({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  // Convertir un objet Food en format Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
    };
  }
}
