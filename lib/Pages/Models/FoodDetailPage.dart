import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/food.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;
  final Function(Food) onFoodAdded; // Ajusté pour ne prendre qu'un seul paramètre Food

  const FoodDetailPage({Key? key, required this.food, required this.onFoodAdded}) : super(key: key);

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double _quantity = 1.0;

  // Méthode pour mettre à jour les valeurs nutritionnelles en fonction de la quantité
  int _calculateValue(int baseValue) {
    return (baseValue * _quantity).round();
  }

  // Fonction pour ajouter l'aliment avec la quantité spécifiée
  void _addFood() {
    // Crée une copie de l'aliment avec la quantité choisie
    Food foodWithQuantity = Food(
      name: widget.food.name,
      calories: _calculateValue(widget.food.calories),
      carbs: _calculateValue(widget.food.carbs),
      fat: _calculateValue(widget.food.fat),
      protein: _calculateValue(widget.food.protein),
    );

    widget.onFoodAdded(foodWithQuantity); // Appelle la fonction avec le nouvel aliment
    Navigator.pop(context); // Ferme la page après ajout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Détails de l'aliment",
                style: TextStyle(
                  fontSize: 20, // Taille réduite
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10), // Réduire l'espacement
              Text(
                "Quantité (en portions):",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Entrez la quantité",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _quantity = double.tryParse(value) ?? 1.0; // Met à jour la quantité
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressIndicator(
                    "Calories",
                    _calculateValue(widget.food.calories),
                    2000, // AJR
                    Colors.orange,
                  ),
                  _buildProgressIndicator(
                    "Carbs",
                    _calculateValue(widget.food.carbs),
                    300, // AJR
                    Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressIndicator(
                    "Graisses",
                    _calculateValue(widget.food.fat),
                    70, // AJR
                    Colors.red,
                  ),
                  _buildProgressIndicator(
                    "Protéines",
                    _calculateValue(widget.food.protein),
                    50, // AJR
                    Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 30), // Ajout d'espace avant le bouton
              Center( // Centrer le bouton
                child: ElevatedButton(
                  onPressed: _addFood,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                  child: Text(
                    'Ajouter l\'aliment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, int value, int maxValue, Color color) {
    double percentage = (value / maxValue).clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60.0, // Taille réduite
            lineWidth: 8.0, // Épaisseur réduite
            percent: percentage,
            center: Text(
              "$value g",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
