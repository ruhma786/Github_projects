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
  String cityName = util.defaultCity;
  String temperature = '';
  String weatherDescription = '';
  String humidity = '';
  String windSpeed = '';
  String weatherIcon = 'images/light-rain.png';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${util.apiID}&units=imperial';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          temperature = '${data['main']['temp']}°F';
          weatherDescription =
          '${data['weather'][0]['description'][0].toUpperCase()}${data['weather'][0]['description'].substring(1)}'; // Capitalized description
          humidity = '${data['main']['humidity']}%';
          windSpeed = '${data['wind']['speed']} mph';
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
        return 'images/sunny.png';
      case 'clouds':
        return 'images/cloudy.png';
      case 'rain':
        return 'images/rain.png';
      default:
        return 'images/light-rain.png';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  weatherIcon,
                  width: 80.0,
                ),
                const SizedBox(height: 20.0),
                // Display the temperature
                Text(
                  temperature.isNotEmpty ? temperature : 'Loading...',
                  style: tempStyle(),
                ),
                const SizedBox(height: 10.0),
                // Display the weather description
                Text(
                  weatherDescription.isNotEmpty
                      ? 'Condition: $weatherDescription'
                      : 'Loading...',
                  style: detailStyle(),
                ),
                const SizedBox(height: 10.0),
                // Display humidity
                Text(
                  humidity.isNotEmpty ? 'Humidity: $humidity' : 'Loading...',
                  style: detailStyle(),
                ),
                const SizedBox(height: 10.0),
                // Display wind speed
                Text(
                  windSpeed.isNotEmpty ? 'Wind Speed: $windSpeed' : 'Loading...',
                  style: detailStyle(),
                ),
              ],
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

// Text style for weather details (description, humidity, wind speed)
TextStyle detailStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontStyle: FontStyle.normal,
  );
}
