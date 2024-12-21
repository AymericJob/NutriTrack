import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';
import '../Models/FoodDetailPage.dart';
import 'ManualSearchPage.dart'; // Nouvelle page pour la recherche manuelle

class AddFoodPage extends StatefulWidget {
  final Function(Food) onFoodAdded;

  const AddFoodPage({Key? key, required this.onFoodAdded}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _searchController = TextEditingController();
  List<Food> _foodList = [];
  bool _isLoading = false;

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
          final food = Food(
            name: product['product_name'] ?? 'Inconnu',
            calories: (product['nutriments']?['energy-kcal'] ?? 0).toInt(),
            carbs: (product['nutriments']?['carbohydrates'] ?? 0).toInt(),
            fat: (product['nutriments']?['fat'] ?? 0).toInt(),
            protein: (product['nutriments']?['proteins'] ?? 0).toInt(),
            sourceApi: "OpenFoodFacts",
            imageUrl: product['image_url'],
          );
          widget.onFoodAdded(food);  // Appel pour ajouter le food
          Navigator.pop(context);  // Fermer la page après l'ajout
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

  Future<void> _searchFoods() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _foodList.clear();
    });

    try {
      final openFoodFactsResults = _fetchFromOpenFoodFacts(query);
      final edamamResults = _fetchFromEdamamAPI(query);
      final results = await Future.wait([openFoodFactsResults, edamamResults]);

      setState(() {
        _foodList = results.expand((r) => r).toList();
      });
    } catch (e) {
      _showMessage("Erreur de recherche : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Food>> _fetchFromOpenFoodFacts(String query) async {
    final url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&json=true';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['products'] as List;
      return products.map((product) {
        return Food(
          name: product['product_name'] ?? 'Inconnu',
          calories: (product['nutriments']?['energy-kcal'] ?? 0).toInt(),
          carbs: (product['nutriments']?['carbohydrates'] ?? 0).toInt(),
          fat: (product['nutriments']?['fat'] ?? 0).toInt(),
          protein: (product['nutriments']?['proteins'] ?? 0).toInt(),
          sourceApi: "OpenFoodFacts",
          imageUrl: product['image_url'],
        );
      }).toList();
    } else {
      throw Exception("Erreur OpenFoodFacts");
    }
  }

  Future<List<Food>> _fetchFromEdamamAPI(String query) async {
    final apiKey = '24dcad2ef38557ce8c055e032a9e4f16';
    final appID = 'd4394cd3';
    final url = 'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appID&app_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final foodItems = data['hints'] as List;
      return foodItems.map((item) {
        final food = item['food'];
        return Food(
          name: food['label'] ?? 'Inconnu',
          calories: (food['nutrients']?['ENERC_KCAL'] ?? 0).toInt(),
          carbs: (food['nutrients']?['CHOCDF'] ?? 0).toInt(),
          fat: (food['nutrients']?['FAT'] ?? 0).toInt(),
          protein: (food['nutrients']?['PROCNT'] ?? 0).toInt(),
          sourceApi: "Edamam",
          imageUrl: food['image'],
        );
      }).toList();
    } else {
      throw Exception("Erreur Edamam");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un aliment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Recherche en haut de la page
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Recherchez un aliment",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchFoods,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de recherche manuelle
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManualSearchPage(),
                  ),
                );
              },
              child: Text("Recherche manuelle"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _scanBarcode,
              icon: Icon(Icons.camera_alt, size: 20),
              label: Text('Scanner un code-barres'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _foodList.length,
                itemBuilder: (context, index) {
                  final food = _foodList[index];
                  return ListTile(
                    title: Text(food.name),
                    subtitle: Text("Calories: ${food.calories}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailPage(food: food),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
