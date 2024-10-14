import 'package:flutter/material.dart';
import '../Pages/Logs/login_page.dart';
import '../Pages/Logs/register_page.dart';
import '../Pages/Home/main_page.dart';
import '../Pages/Home/Profile/profile_page.dart';
import '../Pages/Home/Profile/personal_info_page.dart';
import '../Pages/Home/Profile/nutrition_goals_page.dart';
import '../Pages/Home/Profile/activity_tracking_page.dart';

class AppRoutes {
  // Anciennes routes
  static const String homePage = '/';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String mainPage = '/main';

  // Nouvelles routes pour le profil
  static const String profilePage = '/profile';
  static const String personalInfoPage = '/personal_info';
  static const String nutritionGoalsPage = '/nutrition_goals';
  static const String activityTrackingPage = '/activity_tracking';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // Anciennes routes
      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerPage:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case mainPage:
        return MaterialPageRoute(builder: (_) => MainPage());

    // Nouvelles routes
      case profilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case personalInfoPage:
        return MaterialPageRoute(builder: (_) => PersonalInfoPage());
      case nutritionGoalsPage:
        return MaterialPageRoute(builder: (_) => NutritionGoalsPage());
      case activityTrackingPage:
        return MaterialPageRoute(builder: (_) => ActivityTrackingPage());

    // Route par défaut
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
