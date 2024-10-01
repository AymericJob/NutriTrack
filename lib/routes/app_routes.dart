import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class AppRoutes {
  static const String landing = '/landing';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';

  // Méthode pour générer les routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page non trouvée')),
          ),
        );
    }
  }
}
