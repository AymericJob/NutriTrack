import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../l10n/intl_en.dart';


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
          SnackBar(content: Text(S.goalSavedSuccess())),
        );
        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        print("Error saving the goal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.goalSaveError())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(S.yourGoalTitle(), style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0, // Supprimer l'ombre de l'appbar pour une apparence plus clean
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.setStepGoal(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 30),
            Text(
              S.enterGoal(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: S.stepGoalHint(),
                labelStyle: TextStyle(color: Colors.blueAccent),
                hintText: S.stepGoalHint(),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                suffixText: 'steps',
                suffixStyle: TextStyle(color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _saveStepGoal(context),
                child: Text(
                  S.saveGoal(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
