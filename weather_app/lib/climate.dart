import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'api.dart';

class Climate extends StatefulWidget {
  const Climate({super.key});
  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            onPressed: () => print('Menu clicked'),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/umbrella.png',
              fit: BoxFit.cover,
            ),
          ),
          // City Name
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Text(
              'Vehari',
              style: cityStyle(),
            ),
          ),
          // Weather Icon
          Center(
            child: Image.asset(
              'images/light-rain.png',
              width: 50.0,
            ),
          ),
          // Temperature
          Positioned(
            bottom: 100.0,
            left: 30.0,
            child: Text(
              '50.32°F',
              style: tempStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return const TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

