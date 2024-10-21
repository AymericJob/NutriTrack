import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart'; // Pour scanner le code-barres
import 'package:cloud_firestore/cloud_firestore.dart'; // Importation nécessaire pour Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Importation pour Firebase Auth
import '../models/food.dart';

class AddFoodPage extends StatefulWidget {
  final Function(Food) onFoodAdded;

  AddFoodPage({required this.onFoodAdded});

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Food> _searchResults = [];

  // Nouvelle méthode pour scanner le code-barres
  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        String barcode = result.rawContent;
        await _fetchProductByBarcode(barcode);
      }
    } catch (e) {
      print('Erreur lors du scan : $e');
    }
  }

  // Méthode pour récupérer les informations du produit via le code-barres
  Future<void> _fetchProductByBarcode(String barcode) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 1) {
        final product = data['product'];
        setState(() {
          _nameController.text = product['product_name'] ?? 'Nom inconnu';
          _caloriesController.text = (product['nutriments']['energy-kcal_100g'] ?? 0).toString();
          _carbsController.text = (product['nutriments']['carbohydrates_100g'] ?? 0).toString();
          _fatController.text = (product['nutriments']['fat_100g'] ?? 0).toString();
          _proteinController.text = (product['nutriments']['proteins_100g'] ?? 0).toString();
        });
      } else {
        print('Produit non trouvé');
      }
    } else {
      print('Erreur lors de la récupération du produit : ${response.statusCode}');
    }
  }

  // Méthode pour rechercher les aliments via des mots-clés
  Future<void> _searchFood(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?action=process&search_terms=$query&json=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> products = data['products'];

      setState(() {
        _searchResults = products.map((item) {
          return Food(
            name: item['product_name'] ?? 'Nom inconnu',
            calories: (item['nutriments']['energy-kcal_100g'] ?? 0).toInt(),
            carbs: (item['nutriments']['carbohydrates_100g'] ?? 0).toInt(),
            fat: (item['nutriments']['fat_100g'] ?? 0).toInt(),
            protein: (item['nutriments']['proteins_100g'] ?? 0).toInt(),
          );
        }).toList();
      });
    } else {
      print('Erreur lors de la recherche des aliments : ${response.statusCode}');
    }
  }

  // Méthode pour enregistrer l'aliment dans Firestore
  Future<void> _saveFoodToFirestore(Food food) async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupère l'ID de l'utilisateur connecté
    if (userId == null) {
      print('Utilisateur non connecté');
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      await userRef.collection('foods').add({
        'name': food.name,
        'calories': food.calories,
        'carbs': food.carbs,
        'fat': food.fat,
        'protein': food.protein,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Aliment ajouté dans Firestore avec succès');
      // Afficher un message de confirmation
      _showSnackBar('Aliment ajouté avec succès !');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'aliment dans Firestore : $e');
      // Afficher un message d'erreur
      _showSnackBar('Erreur lors de l\'ajout de l\'aliment. Veuillez réessayer.');
    }
  }

  // Afficher un SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
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

      widget.onFoodAdded(food); // Appel de la méthode pour mettre à jour l'affichage local

      // Enregistrer l'aliment dans Firestore
      _saveFoodToFirestore(food);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Aliment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Ajouter les Détails de l\'Aliment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(_nameController, 'Nom de l\'aliment', Icons.fastfood),
                _buildTextField(_caloriesController, 'Calories', Icons.local_fire_department),
                _buildTextField(_carbsController, 'Glucides (g)', Icons.stacked_line_chart),
                _buildTextField(_fatController, 'Lipides (g)', Icons.blender),
                _buildTextField(_proteinController, 'Protéines (g)', Icons.fitness_center),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _scanBarcode,
                  child: Text('Scanner un Code-Barres'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher un aliment',
                    prefixIcon: Icon(Icons.search, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (query) => _searchFood(query),
                ),
                SizedBox(height: 10),
                _buildSearchResults(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Ajouter l\'aliment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer une valeur';
          }
          return null;
        },
      ),
    );
  }

  // Affichage des résultats de recherche
  Widget _buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final food = _searchResults[index];
        return ListTile(
          title: Text(food.name),
          subtitle: Text('Calories: ${food.calories} kcal, Glucides: ${food.carbs}g, Lipides: ${food.fat}g, Protéines: ${food.protein}g'),
          onTap: () {
            setState(() {
              _nameController.text = food.name;
              _caloriesController.text = food.calories.toString();
              _carbsController.text = food.carbs.toString();
              _fatController.text = food.fat.toString();
              _proteinController.text = food.protein.toString();
            });
          },
        );
      },
    );
  }
}
