import 'package:flutter/material.dart';
import '../Models/food.dart';

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
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
      appBar: AppBar(title: Text('Ajouter un Aliment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom de l\'aliment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de calories';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: 'Glucides (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fatController,
                decoration: InputDecoration(labelText: 'Lipides (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: 'Protéines (g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Ajouter l\'aliment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
