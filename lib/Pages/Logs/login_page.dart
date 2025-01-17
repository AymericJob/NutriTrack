import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Routes/app_routes.dart';
import '../../l10n/intl_en.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        message = e.message ?? S.loginErrorMessage();
      } else {
        message = 'An unexpected error occurred';
      }
      _showMessage(context, message);
    }
  }

  // Fonction pour réinitialiser le mot de passe
  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage(context, S.loginErrorMessage());
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage(context, S.resetPasswordMessage());
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        message = e.message ?? 'Failed to send password reset email';
      } else {
        message = 'An unexpected error occurred';
      }
      _showMessage(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Flèche pour revenir à la page d'accueil
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30), // Flèche blanche
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  },
                ),
              ),
              // Contenu principal de la page
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: S.emailLabel(), // Traduction du label "Email"
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: S.passwordLabel(), // Traduction du label "Password"
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      ),
                      child: Text(
                        S.loginButton(), // Traduction du bouton "Login"
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => _resetPassword(context),
                      child: Text(
                        S.forgotPassword(), // Traduction du texte "Forgot Password?"
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.registerPage);
                      },
                      child: Text(
                        S.signUpPrompt(), // Traduction du texte "Don’t have an account? Sign Up"
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
