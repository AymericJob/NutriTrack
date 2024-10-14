import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionGoalsPage extends StatelessWidget {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Goals'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Your Daily Nutrition Goals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildGoalSection(
              title: 'Total Calories',
              hintText: 'Enter daily calories',
              controller: _caloriesController,
              unit: 'kcal',
            ),
            SizedBox(height: 20),
            _buildGoalSection(
              title: 'Protein',
              hintText: 'Enter daily protein',
              controller: _proteinController,
              unit: 'g',
            ),
            SizedBox(height: 20),
            _buildGoalSection(
              title: 'Carbohydrates',
              hintText: 'Enter daily carbs',
              controller: _carbsController,
              unit: 'g',
            ),
            SizedBox(height: 20),
            _buildGoalSection(
              title: 'Fat',
              hintText: 'Enter daily fat',
              controller: _fatController,
              unit: 'g',
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveNutritionGoals(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save Goals', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSection({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String unit,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hintText,
                suffixText: unit,
                suffixStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNutritionGoals(BuildContext context) async {
    try {
      final int calories = int.tryParse(_caloriesController.text) ?? 0;
      final int protein = int.tryParse(_proteinController.text) ?? 0;
      final int carbs = int.tryParse(_carbsController.text) ?? 0;
      final int fat = int.tryParse(_fatController.text) ?? 0;

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please sign in to save your goals')),
        );
        return;
      }

      // Save nutrition goals under the user's document ID
      await FirebaseFirestore.instance.collection('nutrition_goals').doc(user.uid).set({
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nutrition goals saved!')),
      );
    } catch (e) {
      print('Error saving goals: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save goals')),
      );
    }
  }

}
