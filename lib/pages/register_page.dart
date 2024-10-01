import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'Inscription'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page d\'inscription!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
