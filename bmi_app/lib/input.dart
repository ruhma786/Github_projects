import 'package:flutter/material.dart';

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
        // backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new repeatcontainercode(colors: Color(0xFF1D1E33),),
                ),
                Expanded(
                  child: new repeatcontainercode(colors: Color(0xFF1D1E33),)
                ),
              ],
            ),
          ),
          Expanded(
            child: new repeatcontainercode(colors: Color(0xFF1D1E33),)
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new repeatcontainercode(colors: Color(0xFF1D1E33),)
                ),
                Expanded(
                  child: new repeatcontainercode(colors: Color(0xFF1D1E33),)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class repeatcontainercode extends StatelessWidget {
   repeatcontainercode({required this.colors});
   final Color colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: colors, // Corrected color definition
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
