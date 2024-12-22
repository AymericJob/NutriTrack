import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';
import 'FoodDetailPage.dart';
class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _foodList = [];
  bool _isLoading = false;

  // Fonction pour effectuer la recherche
  Future<void> _searchFoods() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _foodList.clear(); // Réinitialiser la liste des aliments
    });

    try {
      // Recherche dans plusieurs APIs
      final openFoodFactsResults = _fetchFromOpenFoodFacts(query);
      final edamamResults = _fetchFromEdamamAPI(query);

      // Attendre les résultats des deux APIs
      final results = await Future.wait([openFoodFactsResults, edamamResults]);

      // Fusionner les résultats
      setState(() {
        _foodList = results.expand((r) => r).toList();
      });
    } catch (e) {
      print("Erreur lors de la recherche : $e");  // Affichage de l'erreur dans la console
      _showMessage("Erreur de recherche : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Recherche via OpenFoodFacts
  Future<List<Food>> _fetchFromOpenFoodFacts(String query) async {
    final url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&json=true';
    try {
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
            brand: product['brands'],
            quantity: product['quantity'],
            sourceApi: "OpenFoodFacts",
            imageUrl: product['image_url'],
          );
        }).toList();
      } else {
        print("Erreur OpenFoodFacts : ${response.statusCode}");
        throw Exception("Erreur OpenFoodFacts");
      }
    } catch (e) {
      print("Erreur dans la récupération des données depuis OpenFoodFacts: $e");
      throw Exception("Erreur dans la récupération des données depuis OpenFoodFacts");
    }
  }

  // Recherche via Edamam API avec vos clés
  Future<List<Food>> _fetchFromEdamamAPI(String query) async {
    final apiKey = '24dcad2ef38557ce8c055e032a9e4f16';
    final appID = 'd4394cd3';
    final url = 'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appID&app_key=$apiKey';

    try {
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
            brand: food['brand'],
            quantity: "Quantité non spécifiée",
            sourceApi: "Edamam",
            imageUrl: food['image'],
          );
        }).toList();
      } else {
        print("Erreur Edamam : ${response.statusCode}");
        throw Exception("Erreur Edamam");
      }
    } catch (e) {
      print("Erreur dans la récupération des données depuis Edamam: $e");
      throw Exception("Erreur dans la récupération des données depuis Edamam");
    }
  }

  // Fonction pour afficher des messages d'erreur
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche combinée d'aliments"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche avec soumission au clavier
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchFoods(),  // Lancer la recherche à la soumission
              decoration: InputDecoration(
                hintText: "Recherchez un aliment",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchFoods,  // Recherche manuelle via le bouton
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Affichage de l'état de chargement ou des résultats
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _foodList.length,
                itemBuilder: (context, index) {
                  final food = _foodList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: food.imageUrl != null
                          ? Image.network(
                        food.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.fastfood, size: 50),
                      title: Text(
                        food.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Source : ${food.sourceApi}"),
                      onTap: () {
                        // Redirection vers la page FoodDetailPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailPage(food: food, category: '',),
                          ),
                        );
                      },
                    ),
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
