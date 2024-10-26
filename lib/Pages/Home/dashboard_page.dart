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

  int _calorieGoal = 0;
  int _carbsGoal = 0;
  int _proteinGoal = 0;
  int _fatGoal = 0;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _fetchNutritionGoals();
    _fetchFoods(); // Ajoutez cet appel pour récupérer les aliments
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

  Future<void> _fetchFoods() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('foods')
            .get();

        List<Food> fetchedFoods = snapshot.docs.map((doc) {
          return Food(
              name: doc['name'],
              calories: (doc['calories'] as num).toInt(),
              carbs: (doc['carbs'] as num).toInt(),
              fat: (doc['fat'] as num).toInt(),
              protein: (doc['protein'] as num).toInt());
        }).toList();

        setState(() {
          _foods = fetchedFoods; // Mettez à jour la liste des aliments
        });
      } catch (e) {
        print("Erreur lors de la récupération des aliments: $e");
      }
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularProgressIndicator(
                    'Calories', totalCalories, _calorieGoal, Colors.red),
                _buildCircularProgressIndicator(
                    'Carbs', totalCarbs, _carbsGoal, Colors.blue),
                _buildCircularProgressIndicator(
                    'Protein', totalProtein, _proteinGoal, Colors.green),
                _buildCircularProgressIndicator(
                    'Fat', totalFat, _fatGoal, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Aliments ajoutés',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_foods[index].name),
                    subtitle: Text('Calories: ${_foods[index].calories}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFoodPage(onFoodAdded: _addFood),
                  ),
                );
              },
              child: Text('Ajouter un aliment'),
            ),
            SizedBox(height: 10),
            Text('Pas aujourd\'hui: $_stepsToday'),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgressIndicator(
      String title, int currentValue, int goalValue, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 5),
        CircularProgressIndicator(
          value: goalValue > 0 ? currentValue / goalValue : 0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 8,
        ),
        SizedBox(height: 5),
        Text('$currentValue / $goalValue'),
      ],
    );
  }
}
