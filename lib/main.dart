import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart'; // Add vibration support (optional)

void main() {
  runApp(DigitalClockApp());
}

class DigitalClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: DigitalClockScreen(),
    );
  }
}

class DigitalClockScreen extends StatefulWidget {
  @override
  _DigitalClockScreenState createState() => _DigitalClockScreenState();
}

class _DigitalClockScreenState extends State<DigitalClockScreen> {
  String _time = "";
  String _date = "";
  String _alarmTime = ""; // Stores the user-set alarm time (e.g., "09:30")

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime =
        "${_formatDigits(now.hour)}:${_formatDigits(now.minute)}:${_formatDigits(now.second)}";
    final formattedDate =
        "${now.year}-${_formatDigits(now.month)}-${_formatDigits(now.day)}";

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });

    // Check if the alarm should ring
    if (_alarmTime == "${_formatDigits(now.hour)}:${_formatDigits(now.minute)}") {
      _ringAlarm();
    }
  }

  String _formatDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  void _ringAlarm() {
    // Show a toast notification
    Fluttertoast.showToast(
      msg: "Alarm ringing!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Vibrate the phone (if supported)
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 1000); // Vibrate for 1 second
    }
  }

  void _setAlarm() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _alarmTime = "${_formatDigits(picked.hour)}:${_formatDigits(picked.minute)}";
      });

      // Show a toast confirmation
      Fluttertoast.showToast(
        msg: "Alarm set for $_alarmTime",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digital Clock with Alarm"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time display
            Text(
              _time,
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.w300,
                fontFamily: "RobotoMono",
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            // Date display
            Text(
              _date,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                fontFamily: "RobotoMono",
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 32.0),
            // Alarm display
            Text(
              _alarmTime.isNotEmpty
                  ? "Alarm set for $_alarmTime"
                  : "No alarm set",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setAlarm,
        backgroundColor: Colors.cyanAccent,
        child: Icon(Icons.alarm_add, color: Colors.black),
      ),
    );
  }
}
