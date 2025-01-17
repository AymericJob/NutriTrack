import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../l10n/intl_en.dart';


class NutritionGoalsPage extends StatelessWidget {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.nutritionGoalsTitle()),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildGoalSection(
                title: S.totalCalories(),
                hintText: S.enterDailyCalories(),
                controller: _caloriesController,
                unit: 'kcal',
                icon: Icons.local_fire_department_outlined,
                color: Colors.orange.shade400,
              ),
              SizedBox(height: 20),
              _buildGoalSection(
                title: S.protein(),
                hintText: S.enterDailyProtein(),
                controller: _proteinController,
                unit: 'g',
                icon: Icons.fitness_center_outlined,
                color: Colors.green.shade400,
              ),
              SizedBox(height: 20),
              _buildGoalSection(
                title: S.carbs(),
                hintText: S.enterDailyCarbs(),
                controller: _carbsController,
                unit: 'g',
                icon: Icons.grain_outlined,
                color: Colors.blue.shade400,
              ),
              SizedBox(height: 20),
              _buildGoalSection(
                title: S.fat(),
                hintText: S.enterDailyFat(),
                controller: _fatController,
                unit: 'g',
                icon: Icons.lunch_dining_outlined,
                color: Colors.red.shade400,
              ),
              SizedBox(height: 30),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.setDailyNutritionGoals(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          S.trackNutritionDescription(),
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildGoalSection({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: hintText,
                      suffixText: unit,
                      suffixStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _saveNutritionGoals(context),
        icon: Icon(Icons.save_outlined),
        label: Text(S.saveGoals()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontSize: 18),
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

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.signInPrompt())),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('nutrition_goals').doc(user.uid).set({
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.goalsSavedSuccess()),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      print('Error saving goals: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.goalsSaveError()),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }
}
