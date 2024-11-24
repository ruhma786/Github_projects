import 'package:flutter/material.dart';

class CityInputScreen extends StatelessWidget {
  const CityInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter City'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  final city = cityController.text.trim();
                  if (city.isNotEmpty) {
                    Navigator.pop(context, city);
                  }
                },
                child: const Text('Get Weather'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}