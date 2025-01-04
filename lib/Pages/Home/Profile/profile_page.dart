import 'package:flutter/material.dart';
import '../../../Routes/app_routes.dart'; // Path to AppRoutes

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildInfoCard(
              context,
              title: 'Personal Information',
              routeName: AppRoutes.personalInfoPage,
              icon: Icons.person,
              backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),  // Fond léger de la carte
            ),
            _buildInfoCard(
              context,
              title: 'Nutrition Goals',
              routeName: AppRoutes.nutritionGoalsPage,
              icon: Icons.fastfood,
              backgroundColor: Colors.orangeAccent.withOpacity(0.1),  // Fond léger de la carte
            ),
            _buildInfoCard(
              context,
              title: 'Activity Tracking',
              routeName: AppRoutes.activityTrackingPage,
              icon: Icons.fitness_center,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),  // Fond léger de la carte
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String routeName, required IconData icon, required Color backgroundColor}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 8,  // Ombre plus marquée pour un effet visuel moderne
      shadowColor: Colors.black.withOpacity(0.3), // Ombre plus douce
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Coins arrondis pour une apparence douce
      ),
      color: backgroundColor,  // Appliquer la couleur de fond
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurpleAccent,  // Icône personnalisée en couleur violet accent
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600, // Police plus grasse
            color: Colors.black87, // Couleur de texte foncée pour la lisibilité
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.deepPurpleAccent,  // Icône de flèche avec la même couleur
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName);  // Navigation vers la page
        },
      ),
    );
  }
}
