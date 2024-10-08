import 'package:flutter/material.dart';
import 'Routes/app_routes.dart'; // Corrigez l'importation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fitness Pal',
      initialRoute: AppRoutes.loginPage, // Utilisez la route correcte
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
