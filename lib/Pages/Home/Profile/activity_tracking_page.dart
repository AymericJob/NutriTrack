import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityTrackingPage extends StatelessWidget {
  final TextEditingController _goalController = TextEditingController();

  Future<void> _saveStepGoal(BuildContext context) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        int stepGoal = int.tryParse(_goalController.text) ?? 0;
        await FirebaseFirestore.instance
            .collection('step_goals')
            .doc(uid)
            .set({'goal': stepGoal});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Goal saved successfully!')),
        );
        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        print("Error saving the goal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving the goal.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Goal'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your daily step goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Step Goal',
                suffixText: 'steps',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveStepGoal(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
