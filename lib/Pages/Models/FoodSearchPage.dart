import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Routes/app_routes.dart';
import '../models/food.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _foodList = [];
  bool _isLoading = false;

  Future<void> _searchFoods() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _foodList.clear(); // Réinitialiser la liste des aliments
    });

    final url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&json=true';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'] as List;

        if (products.isNotEmpty) {
          _foodList = products.map((product) {
            return Food(
              name: product['product_name'] ?? 'Inconnu',
              calories: (product['nutriments']?['energy-kcal'] ?? 0).toInt(),
              carbs: (product['nutriments']?['carbohydrates'] ?? 0).toInt(),
              fat: (product['nutriments']?['fat'] ?? 0).toInt(),
              protein: (product['nutriments']?['proteins'] ?? 0).toInt(),
            );
          }).toList();
        } else {
          _showMessage("Aucun produit trouvé.");
        }
      } else {
        _showMessage("Erreur lors de la récupération des données.");
      }
    } catch (e) {
      _showMessage("Erreur de connexion.");
    } finally {
      setState(() {
        _isLoading = false; // Mettre à jour l'état de chargement
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche d'aliments"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Recherchez un aliment",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchFoods, // Lancer la recherche lorsque le bouton est pressé
                ),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search, // Indiquer que l'action du clavier est une recherche
              onSubmitted: (value) {
                // Lancer la recherche lorsque l'utilisateur appuie sur "Enter"
                _searchFoods();
              },
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.foodDetailsPage,
                        arguments: food,
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
