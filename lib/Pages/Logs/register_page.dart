import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Routes/app_routes.dart';
import '../../l10n/intl_en.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Fonction pour afficher les messages
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Fonction pour l'inscription
  void _register(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Vérifier si les mots de passe correspondent
    if (password != confirmPassword) {
      _showMessage(context, S.passwordsDoNotMatch());
      return;
    }

    try {
      // Création de l'utilisateur dans Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération de l'utilisateur authentifié
      User? user = userCredential.user;

      if (user != null) {
        // Créer le document de l'utilisateur dans Firestore
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Affichage d'un message de succès
          _showMessage(context, S.userCreatedSuccessfully());

          // Redirection vers la page principale après l'inscription réussie
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
        } catch (e) {
          _showMessage(context, "Error creating user in Firestore: $e");
        }
      }
    } catch (e) {
      // En cas d'erreur d'inscription
      String message = S.registrationFailed() + ': ';
      if (e is FirebaseAuthException) {
        message += e.message ?? 'Unknown error';
      } else {
        message += e.toString();
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
                    Text(
                      S.signUpLabel(), // Traduction du titre "Sign Up"
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Champ email
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
                    SizedBox(height: 20),
                    // Champ mot de passe
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: S.passwordLabel(), // Traduction du label "Password"
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Champ confirmation du mot de passe
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: S.confirmPasswordLabel(), // Traduction du label "Confirm Password"
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Bouton "Sign Up"
                    ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      ),
                      child: Text(
                        S.signUpButton(), // Traduction du bouton "Sign Up"
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Bouton de redirection vers Sign In
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.loginPage);
                      },
                      child: Text(
                        S.signInPrompt(), // Traduction du texte "Already have an account? Sign In"
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
