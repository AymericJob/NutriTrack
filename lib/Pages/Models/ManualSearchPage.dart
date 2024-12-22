import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  String? _selectedCategory; // Nouvelle variable pour la catégorie
  bool _isLoading = false;

  // Fonction pour ajouter un aliment dans Firestore
  Future<void> _addFoodToFirestore() async {
    final name = _nameController.text;
    final calories = _caloriesController.text.isNotEmpty
        ? int.tryParse(_caloriesController.text)
        : null;
    final carbs = _carbsController.text.isNotEmpty
        ? int.tryParse(_carbsController.text)
        : null;
    final fat = _fatController.text.isNotEmpty
        ? int.tryParse(_fatController.text)
        : null;
    final protein = _proteinController.text.isNotEmpty
        ? int.tryParse(_proteinController.text)
        : null;

    // Vérification que le nom et la catégorie sont remplis
    if (name.isEmpty || _selectedCategory == null) {
      _showMessage("Veuillez remplir tous les champs obligatoires.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer l'utilisateur actuellement connecté
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
        'calories': calories ?? 0, // Utilise 0 si vide
        'carbs': carbs ?? 0, // Utilise 0 si vide
        'fat': fat ?? 0, // Utilise 0 si vide
        'protein': protein ?? 0, // Utilise 0 si vide
        'category': _selectedCategory, // Ajouter la catégorie
        'date': Timestamp.now(),  // Date actuelle d'ajout
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
    setState(() {
      _selectedCategory = null;
    });
  }

  // Afficher un message d'alerte
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un aliment manuellement"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nom de l'aliment"),
                validator: (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: "Calories (par portion)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: "Glucides (g)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fatController,
                decoration: InputDecoration(labelText: "Graisses (g)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: "Protéines (g)"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: "Catégorie"),
                items: ['Déjeuner', 'Dîner', 'Souper', 'Snack']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                value == null ? "Veuillez choisir une catégorie" : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addFoodToFirestore();
                  }
                },
                child: Text("Ajouter l'aliment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
