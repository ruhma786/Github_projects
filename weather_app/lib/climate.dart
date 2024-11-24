import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart' as util; // Custom utility for API keys and default city

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  // State variables for city name, temperature, and weather icon
  String cityName = util.defaultCity;
  String temperature = '';
  String weatherIcon = 'images/light-rain.png';

  @override
  void initState() {
    super.initState();
    fetchWeather(); // Fetch weather when the app initializes
  }

  // Method to fetch weather data from OpenWeatherMap API
  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${util.apiID}&units=imperial';

    try {
      // Send HTTP GET request to API
      final response = await http.get(Uri.parse(url));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);

        // Extract relevant information and update the state
        setState(() {
          temperature = '${data['main']['temp']}°F'; // Temperature in Fahrenheit
          final weatherCondition = data['weather'][0]['main'].toLowerCase();
          weatherIcon = getWeatherIcon(weatherCondition); // Get corresponding weather icon
        });
      } else {
        // Log error if API request fails
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions during the HTTP request
      print('Failed to fetch weather: $e');
    }
  }

  // Helper method to determine the appropriate weather icon
  String getWeatherIcon(String condition) {
    switch (condition) {
      case 'clear':
        return 'images/sunny.png';
      case 'clouds':
        return 'images/cloudy.png';
      case 'rain':
        return 'images/rain.png';
      default:
        return 'images/light-rain.png'; // Default icon
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
          // Display the city name
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Text(
              cityName,
              style: cityStyle(),
            ),
          ),
          // Centered weather icon
          Center(
            child: Image.asset(
              weatherIcon,
              width: 80.0,
            ),
          ),
          // Display the temperature
          Positioned(
            bottom: 100.0,
            left: 30.0,
            child: Text(
              temperature.isNotEmpty ? temperature : 'Loading...', // Show loading text while fetching data
              style: tempStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

// Text style for city name
TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

// Text style for temperature
TextStyle tempStyle() {
  return const TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}
