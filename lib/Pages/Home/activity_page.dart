import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Profile/activity_tracking_page.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _stepsToday = 0;
  int _stepGoal = 0;
  Stream<StepCount>? _stepCountStream;
  DateTime _lastRecordedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _fetchStepGoal();
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(
          (StepCount stepCount) {
        if (_lastRecordedDate.day != DateTime.now().day) {
          _stepsToday = 0;
          _lastRecordedDate = DateTime.now();
        }
        setState(() {
          _stepsToday += stepCount.steps;
        });
      },
      onError: (error) {
        print("Error fetching steps: $error");
      },
    );
  }

  Future<void> _fetchStepGoal() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('step_goals')
            .doc(uid)
            .get();
        if (doc.exists) {
          setState(() {
            _stepGoal = doc['goal'] ?? 0;
          });
        }
      } catch (e) {
        print("Error fetching step goal: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: _fetchStepGoal,
            child: ListView(
              children: [
                SizedBox(height: 16),
                _buildStepsCard(),
                SizedBox(height: 16),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _stepGoal > 0 ? _stepsToday / _stepGoal : 0,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 8),
                Text(
                  '${((_stepsToday / _stepGoal) * 100).toStringAsFixed(1)}% of your goal',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Keep walking to reach your goal!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_stepsToday steps',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Goal: $_stepGoal steps',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.directions_walk,
              size: 40,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
