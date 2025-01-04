import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  // Option pour changer le mot de passe
  void _changePassword(BuildContext context) {
    // Implémenter la logique pour changer le mot de passe
    print("Changing password...");
  }

  // Option pour changer l'email
  void _changeEmail(BuildContext context) {
    // Implémenter la logique pour changer l'email
    print("Changing email...");
  }

  // Option pour gérer les notifications
  void _toggleNotifications(BuildContext context) {
    // Implémenter la logique pour activer/désactiver les notifications
    print("Toggling notifications...");
  }

  // Fonction de déconnexion
  Future<void> _signOut(BuildContext context) async {
    final confirmSignOut = await _showSignOutDialog(context);
    if (confirmSignOut) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }
  }

  Future<bool> _showSignOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Log out', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Change Email'),
              leading: Icon(Icons.email),
              onTap: () => _changeEmail(context),
            ),
            ListTile(
              title: Text('Change Password'),
              leading: Icon(Icons.lock),
              onTap: () => _changePassword(context),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: true, // Pour tester, tu peux remplacer par une vraie valeur d'état
              onChanged: (bool value) {
                _toggleNotifications(context);
              },
              secondary: Icon(Icons.notifications),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
