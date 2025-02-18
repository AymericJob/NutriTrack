import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../l10n/intl_en.dart';

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

  String? _selectedMeal; // Repas du aliment (ex. Déjeuner, Dîner, Souper, Snack)
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now(); // Date par défaut

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

    // Vérifier que tous les champs sont remplis correctement
    if (name.isEmpty || _selectedMeal == null) {
      _showMessage(S.invalidField()); // Utilisation de la traduction
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage(S.userNotAuthenticated()); // Utilisation de la traduction
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final foodRef = userRef.collection('foods').doc(); // Crée un ID unique automatiquement

      // Ajoute l'aliment dans la base de données avec le repas et la date
      await foodRef.set({
        'name': name,
        'calories': calories ?? 0,
        'carbs': carbs ?? 0,
        'fat': fat ?? 0,
        'protein': protein ?? 0,
        'meal': _selectedMeal,  // Remplace "category" par "meal"
        'date': Timestamp.fromDate(_selectedDate),
        'id': foodRef.id,
      });

      _showMessage(S.foodAddedSuccessfully()); // Utilisation de la traduction
      _clearFields();
    } catch (e) {
      _showMessage("${S.errorAddingFood()} $e"); // Utilisation de la traduction
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Sélectionner la date via un DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Réinitialiser les champs du formulaire
  void _clearFields() {
    _nameController.clear();
    _caloriesController.clear();
    _carbsController.clear();
    _fatController.clear();
    _proteinController.clear();
    setState(() {
      _selectedMeal = null;
      _selectedDate = DateTime.now();
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
        title: Text(S.manualSearchTitle()), // Traduction du titre
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
                decoration: InputDecoration(labelText: S.foodNameLabel()), // Traduction du label
                validator: (value) => value!.isEmpty ? S.invalidField() : null, // Traduction du message d'erreur
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: S.caloriesLabel()), // Traduction du label
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: S.carbsLabel()), // Traduction du label
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fatController,
                decoration: InputDecoration(labelText: S.fatLabel()), // Traduction du label
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: S.proteinLabel()), // Traduction du label
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedMeal,
                decoration: InputDecoration(labelText: S.mealLabel()), // Traduction du label
                items: ['Breakfast', 'Lunch', 'Diner', 'Snack']
                    .map((meal) => DropdownMenuItem<String>(
                  value: meal,
                  child: Text(meal),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMeal = value;
                  });
                },
                validator: (value) =>
                value == null ? S.invalidField() : null, // Traduction du message d'erreur
              ),
              SizedBox(height: 20),
              // Sélection de la date
              Text(
                S.dateSelectionLabel(), // Traduction de "Sélectionnez une date"
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
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
                child: Text(S.addFoodButtonLabel()), // Traduction du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
