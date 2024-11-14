//part1
import 'package:flutter/material.dart';

void main() {
  runApp(BmiApp());
}

class BmiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI CALCULATOR"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child:  Text(
          'BMI body',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}