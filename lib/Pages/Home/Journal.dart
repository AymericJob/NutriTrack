import 'package:flutter/material.dart';
import 'package:myfitnesspal/Pages/models/food.dart';

class Journal extends StatelessWidget {
  final List<Food> foods;

  Journal({required this.foods});

  @override
  Widget build(BuildContext context) {
    // Vérifier que la liste des aliments n'est pas vide
    if (foods.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Journal'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text(
            "Aucun aliment consommé pour aujourd'hui.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // Regrouper les aliments par catégorie 'meal'
    Map<String, List<Food>> categorizedFoods = {};

    for (var food in foods) {
      // Utiliser une valeur par défaut si 'meal' est vide ou null
      String mealCategory = food.meal.isEmpty ? 'Non catégorisé' : food.meal;

      if (categorizedFoods.containsKey(mealCategory)) {
        categorizedFoods[mealCategory]!.add(food);
      } else {
        categorizedFoods[mealCategory] = [food];
      }
    }

    // Tri des catégories par ordre alphabétique
    var sortedCategories = categorizedFoods.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            String category = sortedCategories[index];
            List<Food> foodsInCategory = categorizedFoods[category]!;

            return ExpansionTile(
              title: Text(category),
              children: foodsInCategory.map((food) {
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text(
                    'Calories: ${food.calories} | Glucides: ${food.carbs}g | Lipides: ${food.fat}g | Protéines: ${food.protein}g',
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
