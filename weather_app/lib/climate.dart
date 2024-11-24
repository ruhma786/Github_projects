import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  String cityName = defaultCity;
  String temperature = '';
  String weatherIcon = 'images/light-rain.png';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiID&units=imperial';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = '${data['main']['temp']}°F';
          final weatherCondition = data['weather'][0]['main'].toLowerCase();
          weatherIcon = getWeatherIcon(weatherCondition);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch weather: $e');
    }
  }

  String getWeatherIcon(String condition) {
    switch (condition) {
      case 'clear':
        return 'images/light-rain.png';
      case 'clouds':
        return 'images/cloudy.png';
      case 'rain':
        return 'images/rain.png';
      default:
        return 'images/sunny.png';
    }
  }

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
              cityName,
              style: cityStyle(),
            ),
          ),
          // Weather Icon
          Center(
            child: Image.asset(
              weatherIcon,
              width: 80.0,
            ),
          ),
          // Temperature
          Positioned(
            bottom: 100.0,
            left: 30.0,
            child: Text(
              temperature.isNotEmpty ? temperature : 'Loading...',
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
