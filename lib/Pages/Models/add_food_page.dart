// Pages/Home/AddFoodPage.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../models/food.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/FoodDetailPage.dart'; // Assurez-vous que ce chemin est correct
import 'FoodSearchPage.dart'; // Assurez-vous que ce chemin est correct


class AddFoodPage extends StatefulWidget {
  final Function(Food) onFoodAdded;

  const AddFoodPage({Key? key, required this.onFoodAdded}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();

  Future<void> _scanBarcode() async {
    try {
      final ScanResult result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        _fetchFoodData(result.rawContent);
      } else {
        _showMessage("Aucun contenu scanné.");
      }
    } catch (e) {
      _showMessage("Erreur lors du scan. Veuillez réessayer.");
    }
  }

  Future<void> _fetchFoodData(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['product'] != null) {
          final product = data['product'];
          _nameController.text = product['product_name'] ?? 'Inconnu';
          _caloriesController.text = product['nutriments']?['energy-kcal']?.toString() ?? '0';
          _carbsController.text = product['nutriments']?['carbohydrates']?.toString() ?? '0';
          _fatController.text = product['nutriments']?['fat']?.toString() ?? '0';
          _proteinController.text = product['nutriments']?['proteins']?.toString() ?? '0';

          // Créez l'objet Food et naviguez vers FoodDetailsPage
          final food = Food(
            name: _nameController.text,
            calories: int.parse(_caloriesController.text),
            carbs: int.parse(_carbsController.text),
            fat: int.parse(_fatController.text),
            protein: int.parse(_proteinController.text),
          );

          // Naviguer vers la page FoodDetails avec l'objet food
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailPage(food: food),
            ),
          );
        } else {
          _showMessage("Produit non trouvé.");
        }
      } else {
        _showMessage("Erreur lors de la récupération des données.");
      }
    } catch (e) {
      _showMessage("Erreur de connexion.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final food = Food(
        name: _nameController.text,
        calories: int.parse(_caloriesController.text),
        carbs: int.parse(_carbsController.text),
        fat: int.parse(_fatController.text),
        protein: int.parse(_proteinController.text),
      );

      widget.onFoodAdded(food);
      _saveFoodToFirestore(food);
      Navigator.pop(context);
    }
  }

  Future<void> _saveFoodToFirestore(Food food) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('foods')
            .add({
          'name': food.name,
          'calories': food.calories,
          'carbs': food.carbs,
          'fat': food.fat,
          'protein': food.protein,
        });
      } catch (e) {
        print("Erreur lors de l'enregistrement de l'aliment: $e");
      }
    }
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodSearchPage(), // Alimentez avec une liste d'aliments si disponible
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un aliment'),
        backgroundColor: Colors.teal,
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(_nameController, "Nom de l'aliment"),
                  _buildTextField(_caloriesController, "Calories", isNumeric: true),
                  _buildTextField(_carbsController, "Glucides", isNumeric: true),
                  _buildTextField(_fatController, "Matières grasses", isNumeric: true),
                  _buildTextField(_proteinController, "Protéines", isNumeric: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scanBarcode,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                    child: Text('Scanner un code-barres', style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _navigateToSearchPage, // Rediriger vers la page de recherche
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                    child: Text('Rechercher un aliment', style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      ),
                      child: Text('Ajouter', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $label';
        }
        return null;
      },
    );
  }
}
