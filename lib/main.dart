import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/Logs/login_page.dart';
import '../Pages/Logs/register_page.dart';
import '../Pages/Home/main_page.dart';
import '../Pages/Logs/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Routes/app_routes.dart';  // Import des routes définies

// Déclarez une clé de navigation globale pour pouvoir utiliser context n'importe où
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Fonction pour gérer les messages reçus en arrière-plan
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Message reçu en arrière-plan : ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure le gestionnaire pour les messages en arrière-plan
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Configuration de Firebase Messaging
  void _setupFirebaseMessaging() async {
    // Demander la permission pour les notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission pour les notifications accordée');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Permission provisoire pour les notifications accordée');
    } else {
      print('Permission pour les notifications refusée');
    }

    // Obtenir le token Firebase pour identifier l'appareil
    String? token = await _firebaseMessaging.getToken();
    print("Token Firebase Messaging : $token");

    // Gérer les notifications en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Notification reçue en premier plan : ${message.notification!.title}");
        _showNotificationDialog(message.notification!);
      }
    });

    // Gérer les notifications ouvertes par l'utilisateur
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification ouverte : ${message.data}");
      // Naviguer vers une page spécifique si nécessaire
      // Par exemple, aller vers une page de notifications
      if (message.data.containsKey('route')) {
        navigatorKey.currentState?.pushNamed(message.data['route']);
      }
    });
  }

  // Affiche un dialogue pour les notifications reçues en premier plan
  void _showNotificationDialog(RemoteNotification notification) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(notification.title ?? "Notification"),
        content: Text(notification.body ?? "Vous avez reçu une notification"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Configuration Firebase Messaging
    _setupFirebaseMessaging();

    return MaterialApp(
      navigatorKey: navigatorKey,  // Ajoutez la clé de navigation ici
      debugShowCheckedModeBanner: false,
      title: 'NutriTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.hasData ? MainPage() : HomePage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      onGenerateRoute: AppRoutes.generateRoute,  // Ajouter la gestion des routes
    );
  }
}
