import 'package:flutter/material.dart';
import '../Pages/Logs/login_page.dart';
import '../Pages/Logs/register_page.dart';
import '../Pages/Home/main_page.dart';

class AppRoutes {
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String mainPage = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerPage:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case mainPage:
        return MaterialPageRoute(builder: (_) => MainPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
