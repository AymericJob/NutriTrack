import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../l10n/intl_en.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Option pour changer le mot de passe
  void _changePassword(BuildContext context) async {
    String? newPassword = await _showPasswordDialog(context);
    if (newPassword != null && newPassword.isNotEmpty) {
      if (newPassword.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.passwordError())));
        return;
      }
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updatePassword(newPassword);
        print("Password changed");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.passwordUpdated())));
      } catch (e) {
        print("Error changing password: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.errorUpdatingPassword())));
      }
    }
  }

  // Option pour changer l'email
  void _changeEmail(BuildContext context) async {
    String? newEmail = await _showEmailDialog(context);
    if (newEmail != null && newEmail.isNotEmpty) {
      if (!_isValidEmail(newEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.emailError())));
        return;
      }
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updateEmail(newEmail);
        print("Email changed to $newEmail");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.emailUpdated())));
        // Déconnecter l'utilisateur après avoir changé l'email
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/login');
      } catch (e) {
        print("Error changing email: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.errorUpdatingEmail())));
      }
    }
  }

  // Option pour gérer les notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value; // Mise à jour de l'état
    });
    print("Notifications toggled: $_isNotificationsEnabled");
  }

  // Fonction pour valider l'email
  bool _isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Fonction pour afficher un dialogue pour entrer un nouvel email
  Future<String?> _showEmailDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.enterNewEmail()),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(hintText: 'New Email'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.cancel()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _emailController.text);
              },
              child: Text(S.submit()),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher un dialogue pour entrer un nouveau mot de passe
  Future<String?> _showPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.enterNewPassword()),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'New Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.cancel()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _passwordController.text);
              },
              child: Text(S.submit()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.settingsTitle()), // Traduction du titre
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(S.changeEmail(), style: TextStyle(fontSize: 18)),
              leading: FaIcon(FontAwesomeIcons.envelope, color: Colors.blueAccent), // Icon Font Awesome
              onTap: () => _changeEmail(context),
            ),
            Divider(),
            ListTile(
              title: Text(S.changePassword(), style: TextStyle(fontSize: 18)),
              leading: FaIcon(FontAwesomeIcons.key, color: Colors.blueAccent), // Icon Font Awesome
              onTap: () => _changePassword(context),
            ),
            Divider(),
            SwitchListTile(
              title: Text(S.enableNotifications(), style: TextStyle(fontSize: 18)),
              value: _isNotificationsEnabled,
              onChanged: _toggleNotifications,
              secondary: FaIcon(FontAwesomeIcons.bell, color: Colors.blueAccent), // Icon Font Awesome
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
