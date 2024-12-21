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
        'createdAt': Timestamp.now(),  // Date actuelle d'ajout
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
                validator: (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: "Glucides (g)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
              ),
              TextFormField(
                controller: _fatController,
                decoration: InputDecoration(labelText: "Graisses (g)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: "Protéines (g)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
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
