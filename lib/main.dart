import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importer Firebase
import 'Routes/app_routes.dart'; // Importer les routes
import 'firebase_options.dart'; // Importer les options Firebase
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/Logs/login_page.dart';
import '../Pages/Logs/register_page.dart';
import '../Pages/Home/main_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les widgets sont initialisés
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialiser Firebase avec les options
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Fitness Pal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Utiliser un StreamBuilder pour gérer l'état d'authentification
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Écouter les changements d'état d'authentification
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Si l'utilisateur est connecté, aller à MainPage, sinon aller à LoginPage
            return snapshot.hasData ? MainPage() : LoginPage();
          }
          return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement pendant le chargement
        },
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
