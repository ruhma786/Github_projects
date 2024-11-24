import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_data.dart';
import 'city_input_screen.dart';
import 'api.dart' as util;

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
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${util.apiID}&units=metric'; // Change units to metric for Celsius

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          temperature = '${data['main']['temp']}°C';  // Show temperature in Celsius
          weatherDescription =
          '${data['weather'][0]['description'][0].toUpperCase()}${data['weather'][0]['description'].substring(1)}';
          humidity = '${data['main']['humidity']}%';
          windSpeed = '${data['wind']['speed']} m/s';  // Adjust wind speed unit for metric
          weatherIcon = WeatherData.getWeatherIcon(data['weather'][0]['main'].toLowerCase());
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch weather: $e');
    }
  }

  void navigateToCityInputScreen() async {
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CityInputScreen()),
    );
    if (selectedCity != null) {
      setState(() {
        cityName = selectedCity;
        fetchWeather();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: navigateToCityInputScreen,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/umbrella.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Text(cityName, style: cityStyle()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(weatherIcon, width: 80.0),
                const SizedBox(height: 20.0),
                Text(temperature.isNotEmpty ? temperature : 'Loading...', style: tempStyle()),
                const SizedBox(height: 10.0),
                Text(
                  weatherDescription.isNotEmpty
                      ? 'Condition: $weatherDescription'
                      : 'Loading...',
                  style: detailStyle(),
                ),
                const SizedBox(height: 10.0),
                Text(humidity.isNotEmpty ? 'Humidity: $humidity' : 'Loading...', style: detailStyle()),
                const SizedBox(height: 10.0),
                Text(windSpeed.isNotEmpty ? 'Wind Speed: $windSpeed' : 'Loading...', style: detailStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() => const TextStyle(color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);

TextStyle tempStyle() => const TextStyle(color: Colors.white, fontSize: 49.9, fontWeight: FontWeight.w500);

TextStyle detailStyle() => const TextStyle(color: Colors.white, fontSize: 20.0);

