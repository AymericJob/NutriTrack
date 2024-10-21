import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food.dart';
import '../Models/add_food_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Food> _foods = [];
  int _stepsToday = 0;
  Stream<StepCount>? _stepCountStream;
  DateTime _lastRecordedDate = DateTime.now();

  // Variables pour stocker les objectifs nutritionnels récupérés de Firestore
  int _calorieGoal = 0;
  int _carbsGoal = 0;
  int _proteinGoal = 0;
  int _fatGoal = 0;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _fetchNutritionGoals(); // Récupérer les objectifs nutritionnels depuis Firestore
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(
          (StepCount stepCount) {
        if (_lastRecordedDate.day != DateTime.now().day) {
          _stepsToday = 0;
          _lastRecordedDate = DateTime.now();
        }
        setState(() {
          _stepsToday += stepCount.steps;
        });
      },
      onError: (error) {
        print("Erreur lors de l'obtention des pas: $error");
      },
    );
  }

  // Fonction pour récupérer les objectifs nutritionnels depuis Firestore
  Future<void> _fetchNutritionGoals() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('nutrition_goals')
            .doc(uid)
            .get();
        if (doc.exists) {
          setState(() {
            _calorieGoal = doc['calories'] ?? 0;
            _carbsGoal = doc['carbs'] ?? 0;
            _proteinGoal = doc['protein'] ?? 0;
            _fatGoal = doc['fat'] ?? 0;
          });
        } else {
          print("Aucun objectif trouvé pour cet utilisateur.");
        }
      } catch (e) {
        print("Erreur lors de la récupération des objectifs de nutrition: $e");
      }
    } else {
      print("Utilisateur non connecté.");
    }
  }

  void _addFood(Food food) {
    setState(() {
      _foods.add(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculer les macros actuelles consommées
    int totalCalories = _foods.fold(0, (sum, food) => sum + food.calories);
    int totalCarbs = _foods.fold(0, (sum, food) => sum + food.carbs);
    int totalFat = _foods.fold(0, (sum, food) => sum + food.fat);
    int totalProtein = _foods.fold(0, (sum, food) => sum + food.protein);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            // Organiser les indicateurs circulaires en ligne (Row)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularProgressIndicator('Calories', totalCalories, _calorieGoal, Colors.red),
                _buildCircularProgressIndicator('Carbs', totalCarbs, _carbsGoal, Colors.blue),
                _buildCircularProgressIndicator('Fat', totalFat, _fatGoal, Colors.green),
                _buildCircularProgressIndicator('Protein', totalProtein, _proteinGoal, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            // Bouton Ajouter un Aliment sous les indicateurs
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodPage(onFoodAdded: _addFood),
                    ),
                  );
                },
                child: Text('Ajouter un Aliment'),
              ),
            ),
            SizedBox(height: 20),
            _buildStatsCard(
              icon: FontAwesomeIcons.walking,
              title: 'Steps Today: $_stepsToday / 10,000',
              subtitle: 'Exercise: 400 cal, 1:01 hr',
            ),
            _buildStatsCard(
              icon: FontAwesomeIcons.weight,
              title: 'Weight: XX kg',
            ),
            SizedBox(height: 20),
            _buildListTile(
              icon: FontAwesomeIcons.utensils,
              title: 'Today\'s Meals',
            ),
            _buildListTile(
              icon: FontAwesomeIcons.chartPie,
              title: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgressIndicator(String label, int value, int goal, Color color) {
    double progress = (goal > 0) ? value / goal : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Le cercle avec la progression
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
        SizedBox(height: 10), // Espacement entre le cercle et le texte
        // Valeur actuelle en dessous du cercle
        Text(
          '$value / $goal',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 5), // Petit espacement entre les valeurs et le label
        // Label du macro (Calories, Carbs, etc.)
        Text(
          label,
          style: TextStyle(fontSize: 16, color: color),
        ),
      ],
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
    _stepCountStream?.listen((_) {}).cancel();
    super.dispose();
  }
}
