import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/food.dart';
import 'FoodDetailPage.dart'; // Assurez-vous que vous avez une page pour afficher les détails de l'aliment.

class ManualSearchPage extends StatefulWidget {
  @override
  _ManualSearchPageState createState() => _ManualSearchPageState();
}

class _ManualSearchPageState extends State<ManualSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();

  bool _isLoading = false;

  // Fonction pour ajouter un aliment dans Firestore
  Future<void> _addFoodToFirestore() async {
    final name = _nameController.text;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final carbs = int.tryParse(_carbsController.text) ?? 0;
    final fat = int.tryParse(_fatController.text) ?? 0;
    final protein = int.tryParse(_proteinController.text) ?? 0;

    if (name.isEmpty || calories == 0 || carbs == 0 || fat == 0 || protein == 0) {
      _showMessage("Veuillez remplir tous les champs.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer l'ID de l'utilisateur actuellement connecté
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage("Vous devez être connecté pour ajouter un aliment.");
        return;
      }

      // Référencer la collection "users" dans Firestore
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final foodRef = userRef.collection('foods');

      // Créer un document pour l'aliment avec les informations fournies
      await foodRef.add({
        'name': name,
        'calories': calories,
        'carbs': carbs,
        'fat': fat,
        'protein': protein,
        'createdAt': Timestamp.now(),
      });

      _showMessage("Aliment ajouté avec succès !");
      _clearFields(); // Réinitialiser les champs du formulaire après l'ajout
    } catch (e) {
      _showMessage("Erreur lors de l'ajout de l'aliment : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Réinitialiser les champs du formulaire
  void _clearFields() {
    _nameController.clear();
    _caloriesController.clear();
    _carbsController.clear();
    _fatController.clear();
    _proteinController.clear();
  }

  // Afficher un message d'alerte
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un aliment"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de texte pour le nom de l'aliment
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nom de l'aliment"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'aliment';
                  }
                  return null;
                },
              ),
              // Champ de texte pour les calories
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les calories';
                  }
                  return null;
                },
              ),
              // Champ de texte pour les glucides
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: "Glucides (g)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les glucides';
                  }
                  return null;
                },
              ),
              // Champ de texte pour les matières grasses
              TextFormField(
                controller: _fatController,
                decoration: InputDecoration(labelText: "Matières grasses (g)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les matières grasses';
                  }
                  return null;
                },
              ),
              // Champ de texte pour les protéines
              TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: "Protéines (g)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les protéines';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Bouton pour ajouter l'aliment
              ElevatedButton(
                onPressed: _isLoading ? null : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _addFoodToFirestore();
                  }
                },
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Ajouter l'aliment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
