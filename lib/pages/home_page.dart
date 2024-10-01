import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenue sur notre application !',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page de connexion
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Se connecter'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page d'inscription
                Navigator.pushNamed(context, '/register');
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
