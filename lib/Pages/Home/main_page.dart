import 'package:flutter/material.dart';

// Pages individuelles à importer
import 'dashboard_page.dart';  // Le tableau de bord principal
import 'activity_page.dart';   // La page des activités
import 'profile_page.dart';    // La page de profil

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar pour le titre de l'application
      appBar: AppBar(
        title: Text('My Fitness Pal'),
        backgroundColor: Colors.blue.shade700,
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
