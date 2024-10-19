import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Routes/app_routes.dart';

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
        message = e.message ?? 'An error occurred during login';
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
      _showMessage(context, "Please enter your email");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage(context, "Password reset email sent. Please check your inbox.");
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
            colors: [Colors.blue.shade400, Colors.purple.shade300],
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
                    Navigator.of(context).pushReplacementNamed('/homepage'); // Remplacez '/homepage' par le nom de votre route home_page.
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
                        labelText: 'Email',
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
                        labelText: 'Password',
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
                        foregroundColor: Colors.blue.shade700,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Lien "Mot de passe oublié"
                    TextButton(
                      onPressed: () => _resetPassword(context),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Lien pour s'inscrire
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.registerPage);
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
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
