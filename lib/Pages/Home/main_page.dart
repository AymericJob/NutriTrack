import 'package:flutter/material.dart';
import '../Home/dashboard_page.dart';  // Le tableau de bord principal
import '../Home/activity_page.dart';   // La page des activités
import '../Home/profile_page.dart';    // La page de profil
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Liste des pages (widgets) à afficher selon l'onglet sélectionné
  final List<Widget> _pages = [
    DashboardPage(),
    ActivityPage(),
    ProfilePage(),
  ];

  // Fonction pour mettre à jour l'index de la page sélectionnée
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fonction pour déconnecter l'utilisateur
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // La déconnexion redirigera automatiquement vers LoginPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Fitness Pal'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Affiche la page selon l'onglet sélectionné
      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue.shade700,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
