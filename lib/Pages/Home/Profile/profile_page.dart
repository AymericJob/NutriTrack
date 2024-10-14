import 'package:flutter/material.dart';
import '../../../Routes/app_routes.dart'; // Path to AppRoutes

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildInfoCard(
              context,  // Add context
              title: 'Personal Information',
              routeName: AppRoutes.personalInfoPage,
            ),
            _buildInfoCard(
              context,  // Add context
              title: 'Nutrition Goals',
              routeName: AppRoutes.nutritionGoalsPage,
            ),
            _buildInfoCard(
              context,  // Add context
              title: 'Activity Tracking',
              routeName: AppRoutes.activityTrackingPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String routeName}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, routeName);  // Add context
        },
      ),
    );
  }
}
