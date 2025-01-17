import 'package:flutter/material.dart';
import '../../../Routes/app_routes.dart'; // Path to AppRoutes
import '../../../l10n/intl_en.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildInfoCard(
              context,
              title: S.personalInfo(),
              routeName: AppRoutes.personalInfoPage,
              icon: Icons.person,
              backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
            ),
            _buildInfoCard(
              context,
              title: S.nutritionGoals(),
              routeName: AppRoutes.nutritionGoalsPage,
              icon: Icons.fastfood,
              backgroundColor: Colors.orangeAccent.withOpacity(0.1),
            ),
            _buildInfoCard(
              context,
              title: S.activityTracking(),
              routeName: AppRoutes.activityTrackingPage,
              icon: Icons.fitness_center,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String routeName, required IconData icon, required Color backgroundColor}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: backgroundColor,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.deepPurpleAccent,
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}
