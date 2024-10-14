import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permet le défilement si nécessaire
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section des macros
              Text(
                'Macros',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroCard('Carbs', 50, 165, Colors.blue),
                  _buildMacroCard('Fat', 35, 65, Colors.green),
                  _buildMacroCard('Protein', 65, 85, Colors.orange),
                ],
              ),
              SizedBox(height: 20),
              // Section des pas
              _buildStatsCard(
                icon: FontAwesomeIcons.walking,
                title: 'Pas: 6,342 / 10,000',
                subtitle: 'Exercice: 400 cal, 1:01 hr',
              ),
              // Section du poids
              _buildStatsCard(
                icon: FontAwesomeIcons.weight,
                title: 'Poids: XX kg', // Remplacez XX par le poids
                onTap: () {
                  // Action à définir
                },
              ),
              SizedBox(height: 20),
              // Liste pour les repas et les exercices
              _buildListTile(
                icon: FontAwesomeIcons.utensils,
                title: 'Repas d\'aujourd\'hui',
                onTap: () {
                  // Action à définir
                },
              ),
              _buildListTile(
                icon: FontAwesomeIcons.dumbbell,
                title: 'Exercices d\'aujourd\'hui',
                onTap: () {
                  // Action à définir
                },
              ),
              _buildListTile(
                icon: FontAwesomeIcons.chartPie,
                title: 'Statistiques',
                onTap: () {
                  // Action à définir
                },
              ),
              // Ajoutez d'autres ListTile ou widgets ici
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCard(String label, int value, int goal, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value / $goal g',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({required IconData icon, required String title, String? subtitle, void Function()? onTap}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required void Function()? onTap}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
