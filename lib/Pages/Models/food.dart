class Food {
  final String name;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final String? brand;
  final String? quantity;
  final String? sourceApi;
  final String? imageUrl;
  final String? category; // Nouvelle propriété pour la catégorie

  Food({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    this.brand,
    this.quantity,
    this.sourceApi,
    this.imageUrl,
    this.category,
  });
}
