import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/intl_en.dart';
import 'NotificationsPage.dart';
import 'dashboard_page.dart';
import 'activity_page.dart';
import 'Profile/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardPage(),
    ActivityPage(),
    ProfilePage(),
  ];

  Future<int> _getCurrentStepCount() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('step_counts')
            .doc(uid)
            .get();
        if (docSnapshot.exists) {
          return docSnapshot['steps'] ?? 0;
        }
      } catch (e) {
        print("Error fetching step count: $e");
      }
    }
    return 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          title: Text(S.logOutTitle(), style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(S.logOutMessage()),
          actions: [
            TextButton(
              child: Text(S.cancel(), style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(S.logOut(), style: TextStyle(color: Colors.red)),
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
        title: Text(S.appTitle()),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.appTitle(), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(S.welcomeMessage(FirebaseAuth.instance.currentUser?.email ?? 'User'),
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(S.settings()),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(S.moreAboutUs()),
            onTap: () {
              // Action pour ouvrir la page À propos
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(S.logOutDrawer()),
            onTap: () => _signOut(context),
          ),
          FutureBuilder<int>(
            future: _getCurrentStepCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text(S.loadingStepCount()),
                );
              }
              if (snapshot.hasError) {
                return ListTile(
                  title: Text(S.errorStepCount()),
                );
              }
              int stepCount = snapshot.data ?? 0;
              return ListTile(
                leading: Icon(Icons.directions_walk),
                title: Text('${S.currentStepCount()}$stepCount'),
              );
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.blueAccent,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: S.Dashboard()),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.fitness_center),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                ),
              ),
            ],
          ),
          label: S.Activity(),
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: S.Profile()),
      ],
    );
  }
}
