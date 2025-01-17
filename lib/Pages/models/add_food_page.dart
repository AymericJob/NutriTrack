// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:myfitnesspal/Pages/Models/ManualSearchPage.dart';
import '../../l10n/intl_en.dart';
import '../models/food.dart';
import 'FoodDetailPage.dart';

class AddFoodPage extends StatefulWidget {
  final void Function(Food food) onFoodAdded;

  const AddFoodPage({Key? key, required this.onFoodAdded}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _searchController = TextEditingController();
  List<Food> _foodList = [];
  bool _isLoading = false;

  // Recherche des aliments par texte dans l'API Open Food Facts
  Future<void> _searchFoods() async {
    setState(() {
      _isLoading = true;
    });

    final query = _searchController.text.trim();

    if (query.isNotEmpty) {
      try {
        // Recherche dans l'API Open Food Facts par nom d'aliment
        final response = await http.get(Uri.parse(
            'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&json=1'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final products = data['products'];

          List<Food> foodList = [];
          for (var product in products) {
            foodList.add(Food(
              name: product['product_name'] ?? 'Inconnu',
              calories: int.tryParse(
                  product['nutriments']['energy-kcal_100g']?.toString() ?? '0') ??
                  0,
              carbs: int.tryParse(
                  product['nutriments']['carbohydrates_100g']?.toString() ?? '0') ??
                  0,
              fat: int.tryParse(
                  product['nutriments']['fat_100g']?.toString() ?? '0') ??
                  0,
              protein: int.tryParse(
                  product['nutriments']['proteins_100g']?.toString() ?? '0') ??
                  0,
              imageUrl: product['image_url'] ?? '',
              sourceApi: 'Open Food Facts',
              meal: '',
              id: '',
            ));
          }

          setState(() {
            _foodList = foodList;
            _isLoading = false;
          });
        } else {
          _showMessage(S.errorFetchingData());
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        _showMessage(S.connectionError(e.toString()));
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _foodList.clear();
        _isLoading = false;
      });
    }
  }

  // Affichage des messages d'erreur
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Fonction de scan du code-barres
  Future<void> _scanBarcode() async {
    try {
      final scanResult = await BarcodeScanner.scan();

      if (scanResult.rawContent.isNotEmpty) {
        setState(() {
          _searchController.text = scanResult.rawContent;
        });

        // Fetch food details using the barcode
        await _fetchFoodFromBarcode(scanResult.rawContent);
      }
    } catch (e) {
      _showMessage(S.barcodeScanError());
    }
  }

  // Fetch food details using the barcode
  Future<void> _fetchFoodFromBarcode(String barcode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://world.openfoodfacts.org/api/v0/product/$barcode.json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final product = data['product'];

        if (product != null) {
          final food = Food(
            name: product['product_name'] ?? 'Inconnu',
            calories: int.tryParse(
                product['nutriments']['energy-kcal_100g']?.toString() ?? '0') ??
                0,
            carbs: int.tryParse(
                product['nutriments']['carbohydrates_100g']?.toString() ?? '0') ??
                0,
            fat: int.tryParse(
                product['nutriments']['fat_100g']?.toString() ?? '0') ??
                0,
            protein: int.tryParse(
                product['nutriments']['proteins_100g']?.toString() ?? '0') ??
                0,
            imageUrl: product['image_url'] ?? '',
            sourceApi: 'Open Food Facts',
            meal: '',
            id: barcode,
          );

          setState(() {
            _isLoading = false;
          });

          // Navigate to the FoodDetailPage with the scanned food data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailPage(
                food: food,
                meal: '',
              ),
            ),
          );
        }
      } else {
        _showMessage(S.errorFetchingData());
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showMessage(S.connectionError(e.toString()));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.addFoodLabel()), // Traduction du titre "Add Food"
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.searchFoodHint(), // Texte d'indice pour la recherche
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchFoods, // Déclenche la recherche
                ),
              ),
            ),
            SizedBox(height: 20),
            // Boutons Scan et Recherche Manuelle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _scanBarcode,  // Scanner le code-barres
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text(S.scanButtonLabel()), // Traduction du bouton "Scan"
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManualSearchPage()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text(S.manualButtonLabel()), // Traduction du bouton "Manual"
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Affichage de l'indicateur de chargement ou des résultats
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _foodList.length,
                itemBuilder: (context, index) {
                  final food = _foodList[index];
                  return ListTile(
                    leading: food.imageUrl != null && food.imageUrl != ''
                        ? Image.network(
                      food.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.fastfood, size: 50),
                    title: Text(food.name),
                    subtitle: Text("Calories: ${food.calories} kcal"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailPage(
                            food: food,
                            meal: '',
                          ),
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
