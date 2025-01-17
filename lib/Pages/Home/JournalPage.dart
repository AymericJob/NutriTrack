import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../l10n/intl_en.dart';
import '../models/food.dart';


class JournalPage extends StatelessWidget {
  final List<Food> foods;

  JournalPage({required this.foods});

  @override
  Widget build(BuildContext context) {
    // Calcul des totaux
    int totalCalories = foods.fold(0, (sum, food) => sum + food.calories);
    int totalCarbs = foods.fold(0, (sum, food) => sum + food.carbs);
    int totalProtein = foods.fold(0, (sum, food) => sum + food.protein);
    int totalFat = foods.fold(0, (sum, food) => sum + food.fat);

    // Créer les données du graphique
    List<NutrientData> chartData = [
      NutrientData(S.calories(), totalCalories),
      NutrientData(S.carbs(), totalCarbs),
      NutrientData(S.protein(), totalProtein),
      NutrientData(S.fat(), totalFat),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.journalTitle()), // Traduction du titre
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre du graphique
            Text(
              S.nutrientDistribution(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Graphique circulaire
            Expanded(
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<NutrientData, String>(
                    dataSource: chartData,
                    xValueMapper: (NutrientData data, _) => data.nutrient,
                    yValueMapper: (NutrientData data, _) => data.value,
                    pointColorMapper: (NutrientData data, _) {
                      switch (data.nutrient) {
                        case 'Calories':
                          return Colors.red;
                        case 'Glucides':
                          return Colors.blue;
                        case 'Protéines':
                          return Colors.green;
                        case 'Lipides':
                          return Colors.orange;
                        default:
                          return Colors.grey;
                      }
                    },
                    enableTooltip: true,
                    radius: '80%',  // Ajuster la taille du graphique
                    explode: true,  // Permet l'effet d'explosion
                    explodeIndex: 0,  // Première section explosée
                  ),
                ],
                // Suppression de l'annotation "Nutrition" au centre
                annotations: [],
              ),
            ),

            SizedBox(height: 20),

            // Résumé des macronutriments sous le graphique
            Text(
              S.summaryOfMacros(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMacroRow(S.calories(), totalCalories, S.kcal()),
                    _buildMacroRow(S.carbs(), totalCarbs, S.grams()),
                    _buildMacroRow(S.protein(), totalProtein, S.grams()),
                    _buildMacroRow(S.fat(), totalFat, S.grams()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher chaque ligne de macronutriment
  Widget _buildMacroRow(String name, int value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '$value $unit',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

// Classe pour contenir les données nutritionnelles
class NutrientData {
  final String nutrient;
  final int value;

  NutrientData(this.nutrient, this.value);
}
