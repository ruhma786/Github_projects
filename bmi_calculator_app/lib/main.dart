import 'package:flutter/material.dart';
import 'input.dart';
void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMICalculatorScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
       textTheme: TextTheme(
         bodyLarge : TextStyle(color: Colors.white)
       )
      ),
    );
  }
}
