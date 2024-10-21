import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Importer le package
import '../models/food.dart';
import 'dart:convert'; // Pour la manipulation JSON
import 'package:http/http.dart' as http; // Pour effectuer des requêtes HTTP

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
      print("Scanning started..."); // Log pour débogage
      final ScanResult result = await BarcodeScanner.scan();
      print("Scanning finished: ${result.rawContent}"); // Log pour débogage
      if (result.rawContent.isNotEmpty) {
        _fetchFoodData(result.rawContent);
      } else {
        _showMessage("Aucun contenu scanné.");
      }
    } catch (e) {
      print("Erreur lors du scan : $e"); // Log pour débogage
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
        } else {
          _showMessage("Produit non trouvé.");
        }
      } else {
        _showMessage("Erreur lors de la récupération des données.");
      }
    } catch (e) {
      print("Erreur lors de l'appel API : $e");
      _showMessage("Erreur de connexion.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ajoutez vos aliments",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_nameController, 'Nom de l\'aliment'),
                  _buildTextField(_caloriesController, 'Calories', isNumeric: true),
                  _buildTextField(_carbsController, 'Carbs (g)', isNumeric: true),
                  _buildTextField(_fatController, 'Graisses (g)', isNumeric: true),
                  _buildTextField(_proteinController, 'Protéines (g)', isNumeric: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scanBarcode, // Appel de la méthode de scan
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                    child: Text(
                      'Scanner un code-barres',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                    child: Text(
                      'Ajouter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.teal, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer une valeur.';
          }
          if (isNumeric && int.tryParse(value) == null) {
            return 'Veuillez entrer un nombre valide.';
          }
          return null;
        },
      ),
    );
  }
}
