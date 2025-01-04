import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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

  Future<void> _deleteFood(Food food) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('foods')
            .where('name', isEqualTo: food.name)
            .where('calories', isEqualTo: food.calories)
            .where('carbs', isEqualTo: food.carbs)
            .where('fat', isEqualTo: food.fat)
            .where('protein', isEqualTo: food.protein)
            .get();

        // Supprimer tous les documents correspondants
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        setState(() {
          _foods.remove(food);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aliment supprimé avec succès.')),
        );
      } catch (e) {
        print("Erreur lors de la suppression de l'aliment: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de supprimer l\'aliment.')),
        );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Aliments consommés',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _deleteFood(_foods[index]);
                    },
                    child: ListTile(
                      title: Text(_foods[index].name),
                      subtitle: Text(
                        'Calories: ${_foods[index].calories} | Glucides: ${_foods[index].carbs}g | Lipides: ${_foods[index].fat}g | Protéines: ${_foods[index].protein}g',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFoodPage(onFoodAdded: _addFood),
                  ),
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Ajouter un aliment',
              backgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalPage(foods: _foods),
                  ),
                );
              },
              child: Icon(Icons.pie_chart),
              tooltip: 'Voir le Journal',
              backgroundColor: Colors.blue,
            ),
          ),
        ],
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
