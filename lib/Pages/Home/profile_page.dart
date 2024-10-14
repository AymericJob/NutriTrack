import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Profile',
            style: _pageTitleStyle,
          ),
          SizedBox(height: 20),
          Text(
            'Edit your personal information, view achievements, etc.',
            style: _pageSubtitleStyle,
          ),
        ],
      ),
    );
  }

  TextStyle get _pageTitleStyle => TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  TextStyle get _pageSubtitleStyle => TextStyle(fontSize: 16);
}
