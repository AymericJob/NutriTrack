import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../l10n/intl_en.dart';


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, String>> _notifications = []; // Liste des notifications reçues

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _notifications.add({
            'title': message.notification!.title ?? S.noTitle(), // Traduction du titre
            'body': message.notification!.body ?? S.noContent(), // Traduction du contenu
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.notificationsTitle()), // Traduction du titre
        backgroundColor: Colors.blueAccent,
      ),
      body: _notifications.isEmpty
          ? Center(child: Text(S.noNotifications())) // Traduction du message lorsqu'il n'y a pas de notifications
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notifications[index]['title']!),
            subtitle: Text(_notifications[index]['body']!),
          );
        },
      ),
    );
  }
}
