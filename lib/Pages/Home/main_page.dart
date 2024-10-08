import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase pour la déconnexion
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

  // Fonction de déconnexion avec une boîte de confirmation
  Future<void> _signOut(BuildContext context) async {
    bool confirmSignOut = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Ne pas déconnecter
              },
            ),
            TextButton(
              child: Text('Sign Out'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmer la déconnexion
              },
            ),
          ],
        );
      },
    );
    if (confirmSignOut) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login'); // Rediriger vers la page de login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar pour le titre de l'application
      appBar: AppBar(
        title: Text('MyFitnessPal'),
        backgroundColor: Colors.blue.shade700,
      ),

      // Drawer (Menu latéral) avec des options
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MyFitnessPal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, ${FirebaseAuth.instance.currentUser?.email ?? 'User'}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Ouvrir la page de paramètres si elle existe
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),

      body: _pages[_selectedIndex], // Affiche la page selon l'onglet sélectionné

      // Barre de navigation inférieure améliorée
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue.shade700,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.fitness_center),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '3', // Exemple de badge (nombre de nouvelles activités)
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
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
