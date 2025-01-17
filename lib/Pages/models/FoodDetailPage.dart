import 'package:flutter/material.dart';
import 'package:myfitnesspal/Pages/Home/main_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/intl_en.dart';
import '../models/food.dart';


class FoodDetailPage extends StatefulWidget {
  final Food food;

  const FoodDetailPage({Key? key, required this.food, required String meal}) : super(key: key);

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double _quantity = 1.0;
  String _selectedMeal = "Breakfast"; // Repas par défaut
  DateTime _selectedDate = DateTime.now(); // Date par défaut (aujourd'hui)

  // Méthode pour calculer les valeurs nutritionnelles ajustées
  int _calculateValue(int baseValue) {
    return (baseValue * _quantity).round();
  }

  // Méthode pour ajouter l'aliment avec le repas sélectionné
  Future<void> _addFood() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('foods')
            .add({
          'name': widget.food.name,
          'calories': _calculateValue(widget.food.calories),
          'carbs': _calculateValue(widget.food.carbs),
          'fat': _calculateValue(widget.food.fat),
          'protein': _calculateValue(widget.food.protein),
          'meal': _selectedMeal, // Le repas sélectionné
          'date': Timestamp.fromDate(_selectedDate), // Enregistrement de la date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.foodAddedSuccessfully())),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.userNotAuthenticated())),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.errorAddingFood())),
      );
      print("Erreur lors de l'ajout de l'aliment : $e");
    }
  }

  // Sélecteur de la date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
        backgroundColor: Colors.blueAccent,
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
                S.foodDetailTitle(), // Traduction du titre "Food Details"
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Quantité de l'aliment
              Text(
                S.quantityLabel(), // Traduction de "Quantity (in servings)"
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
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _quantity = double.tryParse(value) ?? 1.0;
                  });
                },
              ),
              SizedBox(height: 20),
              // Sélection de repas
              Text(
                S.mealSelectionLabel(), // Traduction de "Select a meal"
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedMeal,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMeal = newValue!;
                  });
                },
                items: <String>[
                  "breakfast",
                  "Lunch",
                  "Diner",
                  "Snack"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Sélection de la date
              Text(
                S.dateSelectionLabel(), // Traduction de "Select a date"
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.dateLabel(_selectedDate), // Traduction de la date sélectionnée
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Affichage des progress indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressIndicator(
                    S.caloriesLabel(), // Traduction de "Calories"
                    _calculateValue(widget.food.calories),
                    2000, // AJR (Apports Journaliers Recommandés)
                    Colors.orange,
                  ),
                  _buildProgressIndicator(
                    S.carbsLabel(), // Traduction de "Carbs"
                    _calculateValue(widget.food.carbs),
                    300, // AJR pour glucides
                    Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressIndicator(
                    S.fatsLabel(), // Traduction de "Fats"
                    _calculateValue(widget.food.fat),
                    70, // AJR pour graisses
                    Colors.red,
                  ),
                  _buildProgressIndicator(
                    S.proteinLabel(), // Traduction de "Proteins"
                    _calculateValue(widget.food.protein),
                    50, // AJR pour protéines
                    Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _addFood,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                  child: Text(S.addFoodButtonLabel(), // Traduction du bouton
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
      String label, int value, int maxValue, Color color) {
    double percentage = (value / maxValue).clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 10.0,
            percent: percentage,
            center: Text(
              "$value g",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
