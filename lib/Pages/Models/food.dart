class Food {
  final String name;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final String? brand;
  final String? quantity;
  final String? sourceApi; // Ajout pour savoir d'où viennent les données
  final String? imageUrl;

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
  });
}
