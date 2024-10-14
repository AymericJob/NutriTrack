import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Ajouté pour scanner le code-barres
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

  // Nouvelle méthode pour scanner le code-barres
  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        // Utilisez le code-barres scanné ici
        // Exemple : Rechercher les informations de l'aliment en fonction du code-barres
        // Ici, nous allons simplement l'afficher dans le champ de nom
        setState(() {
          _nameController.text = result.rawContent; // Si le code-barres est le nom de l'aliment
        });
      }
    } catch (e) {
      print('Erreur lors du scan : $e');
    }
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
                  onPressed: _scanBarcode, // Ouvrir la caméra pour scanner le code-barres
                  child: Text('Scanner un Code-Barres'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Couleur du bouton
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Ajouter l\'aliment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Couleur du bouton
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
            borderSide: BorderSide(color: Colors.teal),
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
}
