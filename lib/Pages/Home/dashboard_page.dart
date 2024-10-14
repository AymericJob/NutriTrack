import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import '../models/food.dart';
import '../Models/add_food_page.dart';
import 'package:intl/intl.dart'; // Pour manipuler les dates

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Food> _foods = [];
  int _stepsToday = 0; // Nombre de pas aujourd'hui
  Stream<StepCount>? _stepCountStream;
  DateTime _lastRecordedDate = DateTime.now(); // Date de la dernière mise à jour des pas

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  void _initPedometer() {
    // Écoute des changements de pas
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(
          (StepCount stepCount) {
        // Vérifiez si la date a changé
        if (_lastRecordedDate.day != DateTime.now().day) {
          // Réinitialisez le compteur de pas pour le nouveau jour
          _stepsToday = 0;
          _lastRecordedDate = DateTime.now();
        }

        // Ajoutez les pas à la journée actuelle
        setState(() {
          _stepsToday += stepCount.steps; // Mettez à jour le nombre de pas
        });
      },
      onError: (error) {
        print("Erreur lors de l'obtention des pas: $error");
      },
    );
  }

  void _addFood(Food food) {
    setState(() {
      _foods.add(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalCalories = _foods.fold(0, (sum, food) => sum + food.calories);
    int totalCarbs = _foods.fold(0, (sum, food) => sum + food.carbs);
    int totalFat = _foods.fold(0, (sum, food) => sum + food.fat);
    int totalProtein = _foods.fold(0, (sum, food) => sum + food.protein);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFoodPage(onFoodAdded: _addFood),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Macros',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroCard('Carbs', totalCarbs, 165, Colors.blue),
                  _buildMacroCard('Fat', totalFat, 65, Colors.green),
                  _buildMacroCard('Protein', totalProtein, 85, Colors.orange),
                ],
              ),
              SizedBox(height: 20),
              _buildStatsCard(
                icon: FontAwesomeIcons.walking,
                title: 'Pas aujourd\'hui: $_stepsToday / 10,000',
                subtitle: 'Exercice: 400 cal, 1:01 hr',
              ),
              _buildStatsCard(
                icon: FontAwesomeIcons.weight,
                title: 'Poids: XX kg',
              ),
              SizedBox(height: 20),
              _buildListTile(
                icon: FontAwesomeIcons.utensils,
                title: 'Repas d\'aujourd\'hui',
              ),
              _buildListTile(
                icon: FontAwesomeIcons.dumbbell,
                title: 'Exercices d\'aujourd\'hui',
              ),
              _buildListTile(
                icon: FontAwesomeIcons.chartPie,
                title: 'Statistiques',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCard(String label, int value, int goal, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value / $goal g',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({required IconData icon, required String title, String? subtitle}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void dispose() {
    // Annulez l'écouteur lors de la fermeture
    _stepCountStream?.listen((_) {}).cancel();
    super.dispose();
  }
}
