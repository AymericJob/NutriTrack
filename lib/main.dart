import 'package:flutter/material.dart';
import 'routes/app_routes.dart'; // Importation des routes

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bienvenue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.home, // Route initiale
      onGenerateRoute: AppRoutes.generateRoute, // Génération des routes
    );
  }
}
