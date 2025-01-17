import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myfitnesspal/Pages/Home/JournalPage.dart';
import 'package:myfitnesspal/Pages/models/food.dart';
import '../../l10n/intl_en.dart';
import '../Models/add_food_page.dart';
import '../models/FoodDetailPage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Food> _foods = [];
  DateTime _selectedDate = DateTime.now();

  // Objectifs nutritionnels
  int _calorieGoal = 0;
  int _carbsGoal = 0;
  int _proteinGoal = 0;
  int _fatGoal = 0;

  @override
  void initState() {
    super.initState();
    _fetchNutritionGoals();
    _fetchFoodsForDate(_selectedDate); // Récupérer les aliments pour la date actuelle
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
        }
      } catch (e) {
        print("Erreur lors de la récupération des objectifs de nutrition: $e");
      }
    }
  }

  Future<void> _fetchFoodsForDate(DateTime date) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DateTime startOfDay = DateTime(date.year, date.month, date.day);
        DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('foods')
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .get();

        List<Food> fetchedFoods = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Food(
            id: doc.id,
            name: data['name'],
            calories: (data['calories'] as num).toInt(),
            carbs: (data['carbs'] as num).toInt(),
            fat: (data['fat'] as num).toInt(),
            protein: (data['protein'] as num).toInt(),
            meal: data.containsKey('meal') ? data['meal'] as String : '',
          );
        }).toList();

        setState(() {
          _foods = fetchedFoods;
        });
      } catch (e) {
        print("Erreur lors de la récupération des aliments: $e");
      }
    }
  }

  Map<String, List<Food>> _groupFoodsByMeal() {
    Map<String, List<Food>> groupedFoods = {};
    for (var food in _foods) {
      if (!groupedFoods.containsKey(food.meal)) {
        groupedFoods[food.meal] = [];
      }
      groupedFoods[food.meal]!.add(food);
    }
    return groupedFoods;
  }

  @override
  Widget build(BuildContext context) {
    int totalCalories = _foods.fold(0, (sum, food) => sum + food.calories);
    int totalCarbs = _foods.fold(0, (sum, food) => sum + food.carbs);
    int totalFat = _foods.fold(0, (sum, food) => sum + food.fat);
    int totalProtein = _foods.fold(0, (sum, food) => sum + food.protein);

    Map<String, List<Food>> groupedFoods = _groupFoodsByMeal();

    return WillPopScope(
      onWillPop: () async {
        // Empêche le retour en arrière via le bouton retour du téléphone
        return false; // Retourne false pour désactiver le retour
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date et boutons de navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(Duration(days: 1));
                        _fetchFoodsForDate(_selectedDate);
                      });
                    },
                  ),
                  Text(
                    DateFormat('d MMM yyyy').format(_selectedDate),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(Duration(days: 1));
                        _fetchFoodsForDate(_selectedDate);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Section des macros
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularProgressIndicator(
                      S.calories(), totalCalories, _calorieGoal, Colors.red),
                  _buildCircularProgressIndicator(
                      S.carbs(), totalCarbs, _carbsGoal, Colors.blue),
                  _buildCircularProgressIndicator(
                      S.protein(), totalProtein, _proteinGoal, Colors.green),
                  _buildCircularProgressIndicator(
                      S.fat(), totalFat, _fatGoal, Colors.orange),
                ],
              ),
              SizedBox(height: 20),

              // Aliments consommés par catégories
              Text(
                S.consumedFoods(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  children: groupedFoods.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        ...entry.value.map((food) {
                          return Dismissible(
                            key: Key(food.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              String? uid = FirebaseAuth.instance.currentUser?.uid;
                              if (uid != null) {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('foods')
                                      .doc(food.id)
                                      .delete();

                                  setState(() {
                                    _foods.removeWhere((item) => item.id == food.id);
                                  });
                                } catch (e) {
                                  print("Erreur lors de la suppression de l'aliment: $e");
                                }
                              }
                            },
                            child: ListTile(
                              title: Text(food.name),
                              subtitle: Text(
                                'Calories: ${food.calories} | ${S.carbs()}: ${food.carbs}g | ${S.fat()}: ${food.fat}g | ${S.protein()}: ${food.protein}g',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodDetailPage(food: food, meal: ''),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalPage(foods: _foods),
                  ),
                );
              },
              child: Icon(Icons.pie_chart),
              backgroundColor: Colors.green,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFoodPage(onFoodAdded: (food) {
                      setState(() {
                        _foods.add(food);
                      });
                    }),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
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
