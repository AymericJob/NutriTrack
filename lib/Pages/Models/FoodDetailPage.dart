import 'package:flutter/material.dart';
import 'package:myfitnesspal/Pages/Home/main_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Home/dashboard_page.dart';
import '../models/food.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;

  const FoodDetailPage({Key? key, required this.food}) : super(key: key);
  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double _quantity = 1.0;

  // Méthode pour mettre à jour les valeurs nutritionnelles en fonction de la quantité
  int _calculateValue(int baseValue) {
    return (baseValue * _quantity).round();
  }

  // Méthode pour ajouter l'aliment aux données utilisateur et rediriger vers DashboardPage
  Future<void> _addFood() async {
    try {
      // Logique pour ajouter l'aliment à Firestore
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
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Aliment ajouté avec succès")),
        );

        // Redirection vers DashboardPage après l'ajout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : utilisateur non authentifié")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout de l'aliment")),
      );
      print("Erreur lors de l'ajout de l'aliment : $e");
    }
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
                "Détails de l'aliment",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
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
                    _quantity = double.tryParse(value) ?? 1.0;
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
                    2000, // Apport journalier recommandé (AJR)
                    Colors.orange,
                  ),
                  _buildProgressIndicator(
                    "Carbs",
                    _calculateValue(widget.food.carbs),
                    300, // AJR pour les glucides en grammes
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
                    70, // AJR pour les graisses en grammes
                    Colors.red,
                  ),
                  _buildProgressIndicator(
                    "Protéines",
                    _calculateValue(widget.food.protein),
                    50, // AJR pour les protéines en grammes
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
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                  child: Text('Ajouter cet aliment', style: TextStyle(fontSize: 18)),
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
