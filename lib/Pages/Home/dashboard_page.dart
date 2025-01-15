import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myfitnesspal/Pages/Home/Journal.dart';
import 'package:myfitnesspal/Pages/Home/JournalPage.dart';
import 'package:myfitnesspal/Pages/models/food.dart';
import '../Models/add_food_page.dart';

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
          return Food(
            name: doc['name'],
            calories: (doc['calories'] as num).toInt(),
            carbs: (doc['carbs'] as num).toInt(),
            fat: (doc['fat'] as num).toInt(),
            protein: (doc['protein'] as num).toInt(),
            meal: doc['meal'] ?? '', // Assure-toi que "meal" existe
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

    return Scaffold(
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

            // Aliments consommés par catégories
            Text(
              'Aliments consommés',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: groupedFoods.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key, // Nom du repas (ex. : Petit-déjeuner)
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      ...entry.value.map((food) {
                        return Dismissible(
                          key: Key(food.name), // Utilise un identifiant unique
                          background: Container(
                            color: Colors.red, // Fond rouge pour signaler la suppression
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          direction: DismissDirection.endToStart, // Glisse pour supprimer
                          onDismissed: (direction) async {
                            // Supprimer l'aliment de Firestore
                            String? uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid != null) {
                              try {
                                // Supprimer le document correspondant à cet aliment
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('foods')
                                    .doc(food.name) // Utiliser le nom ou un ID unique
                                    .delete();

                                // Mettre à jour l'interface pour refléter la suppression
                                setState(() {
                                  _foods.remove(food);
                                });
                              } catch (e) {
                                print("Erreur lors de la suppression de l'aliment: $e");
                              }
                            }
                          },
                          child: ListTile(
                            title: Text(food.name),
                            subtitle: Text(
                              'Calories: ${food.calories} | Glucides: ${food.carbs}g | Lipides: ${food.fat}g | Protéines: ${food.protein}g',
                            ),
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
                  builder: (context) => Journal(foods: _foods),
                ),
              );
            },
            child: Icon(Icons.book),
            backgroundColor: Colors.orange,
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
    );
  }

  Widget _buildCircularProgressIndicator(
      String label, int current, int goal, Color color) {
    return Column(
      children: [
        CircularProgressIndicator(
          value: goal == 0 ? 0 : current / goal,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        SizedBox(height: 8),
        Text(
          '$label: $current/${goal > 0 ? goal : 0}',
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
