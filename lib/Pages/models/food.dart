import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String name;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final String id;
  final String? brand;
  final String? quantity;
  final String? sourceApi;
  final String? imageUrl;
  final String meal; // Nouvelle propriété pour le repas

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    this.brand,
    this.quantity,
    this.sourceApi,
    this.imageUrl,
    required this.meal,
  });

}
