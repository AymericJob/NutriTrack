import 'package:flutter/material.dart';

class ActivityTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Tracking'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Activity Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
