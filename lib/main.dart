import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importer Firebase
import 'Routes/app_routes.dart'; // Importer les routes
import 'firebase_options.dart'; // Importer les options Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les widgets sont initialisés
  await Firebase.initializeApp(); // Initialiser Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fitness Pal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.loginPage, // Utiliser la route correcte
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
