import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Track your activities',
            style: _pageTitleStyle,
          ),
          SizedBox(height: 20),
          Text(
            'You can log exercises, meals, and more here.',
            style: _pageSubtitleStyle,
          ),
        ],
      ),
    );
  }

  TextStyle get _pageTitleStyle => TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  TextStyle get _pageSubtitleStyle => TextStyle(fontSize: 16);
}
