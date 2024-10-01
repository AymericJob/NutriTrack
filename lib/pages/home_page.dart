// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pas de barre d'application pour garder un design minimaliste
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image centrée
              Image.asset(
                'assets/images/your_image.png', // Chemin de l'image
                height: 300, // Taille de l'image
              ),
              SizedBox(height: 40),

              // Texte d'accueil minimaliste
              Text(
                "Bienvenue dans l'App",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Bouton "Get Started"
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.login); // Redirection vers la page de login
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  // Couleur du texte
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15), // Taille du bouton
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
