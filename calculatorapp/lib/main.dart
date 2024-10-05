import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.lightBlueAccent,
        fontFamily: 'Roboto',
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String selectedCalculator = 'BMI';
  String result = '';

  // Controllers for various calculators
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController billAmountController = TextEditingController();
  TextEditingController tipPercentageController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController exchangeRateController = TextEditingController();
  TextEditingController aController = TextEditingController();
  TextEditingController bController = TextEditingController();
  TextEditingController cController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController value1Controller = TextEditingController();
  TextEditingController value2Controller = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController fuelConsumedController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  String selectedTempUnit = 'Celsius';
  String selectedSDT = 'Speed';

  List<String> toDoList = [];

  Widget _buildCalculatorFields() {
    switch (selectedCalculator) {
      case 'BMI':
        return Column(
          children: [
            _customTextField(weightController, 'Weight (kg)'),
            _customTextField(heightController, 'Height (cm)'),
            _customButton('Calculate BMI', _calculateBMI),
          ],
        );
      case 'Tip':
        return Column(
          children: [
            _customTextField(billAmountController, 'Bill Amount'),
            _customTextField(tipPercentageController, 'Tip Percentage'),
            _customButton('Calculate Tip', _calculateTip),
          ],
        );
      case 'Age':
        return Column(
          children: [
            _customTextField(birthDateController, 'Date of Birth (YYYY-MM-DD)', inputType: TextInputType.datetime),
            _customButton('Calculate Age', _calculateAge),
          ],
        );
      case 'Currency':
        return Column(
          children: [
            _customTextField(amountController, 'Amount'),
            _customTextField(exchangeRateController, 'Exchange Rate'),
            _customButton('Convert Currency', _convertCurrency),
          ],
        );
      case 'Quadratic':
        return Column(
          children: [
            _customTextField(aController, 'Coefficient a'),
            _customTextField(bController, 'Coefficient b'),
            _customTextField(cController, 'Coefficient c'),
            _customButton('Solve Quadratic Equation', _solveQuadratic),
          ],
        );
      case 'Temperature':
        return Column(
          children: [
            _customTextField(temperatureController, 'Temperature'),
            DropdownButton<String>(
              value: selectedTempUnit,
              items: ['Celsius', 'Fahrenheit', 'Kelvin']
                  .map((unit) => DropdownMenuItem(
                value: unit,
                child: Text(unit),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTempUnit = value!;
                });
              },
            ),
            _customButton('Convert Temperature', _convertTemperature),
          ],
        );
      case 'SDT':
        return Column(
          children: [
            _customTextField(value1Controller, 'Value 1'),
            _customTextField(value2Controller, 'Value 2'),
            DropdownButton<String>(
              value: selectedSDT,
              items: ['Speed', 'Distance', 'Time']
                  .map((sdt) => DropdownMenuItem(
                value: sdt,
                child: Text(sdt),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSDT = value!;
                });
              },
            ),
            _customButton('Calculate', _calculateSDT),
          ],
        );
      case 'Discount':
        return Column(
          children: [
            _customTextField(originalPriceController, 'Original Price'),
            _customTextField(discountPercentageController, 'Discount Percentage'),
            _customButton('Calculate Discount', _calculateDiscount),
          ],
        );
      case 'Fuel':
        return Column(
          children: [
            _customTextField(distanceController, 'Distance Travelled (km)'),
            _customTextField(fuelConsumedController, 'Fuel Consumed (liters)'),
            _customButton('Calculate Fuel Efficiency', _calculateFuelEfficiency),
          ],
        );
      case 'ToDo':
        return Column(
          children: [
            _customTextField(taskController, 'Enter task'),
            _customButton('Add Task', _addTask),
            Expanded(
              child: ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(toDoList[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  // Custom text field widget for reuse
  Widget _customTextField(TextEditingController controller, String labelText, {TextInputType inputType = TextInputType.number}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: inputType,
    );
  }

  // Custom button widget for reuse
  Widget _customButton(String label, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }

  // Calculator functions

  void _calculateBMI() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100; // Convert to meters
    if (height > 0) {
      double bmi = weight / (height * height);
      setState(() {
        result = 'Your BMI is ${bmi.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        result = 'Invalid height';
      });
    }
  }

  void _calculateTip() {
    double billAmount = double.parse(billAmountController.text);
    double tipPercentage = double.parse(tipPercentageController.text);
    double tipAmount = billAmount * (tipPercentage / 100);
    double totalAmount = billAmount + tipAmount;
    setState(() {
      result = 'Tip: \$${tipAmount.toStringAsFixed(2)}, Total: \$${totalAmount.toStringAsFixed(2)}';
    });
  }

  void _calculateAge() {
    DateTime birthDate = DateTime.parse(birthDateController.text);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (birthDate.isAfter(today.subtract(Duration(days: today.difference(birthDate).inDays % 365)))) {
      age--;
    }
    setState(() {
      result = 'Your age is $age years';
    });
  }

  void _convertCurrency() {
    double amount = double.parse(amountController.text);
    double exchangeRate = double.parse(exchangeRateController.text);
    double convertedAmount = amount * exchangeRate;
    setState(() {
      result = 'Converted amount is \$${convertedAmount.toStringAsFixed(2)}';
    });
  }

  void _solveQuadratic() {
    double a = double.parse(aController.text);
    double b = double.parse(bController.text);
    double c = double.parse(cController.text);
    double discriminant = (b * b) - 4 * a * c;
    if (discriminant < 0) {
      setState(() {
        result = 'No real roots';
      });
    } else {
      double root1 = (-b + sqrt(discriminant)) / (2 * a);
      double root2 = (-b - sqrt(discriminant)) / (2 * a);
      setState(() {
        result = 'Roots are ${root1.toStringAsFixed(2)} and ${root2.toStringAsFixed(2)}';
      });
    }
  }

  void _convertTemperature() {
    double temperature = double.parse(temperatureController.text);
    double convertedTemperature;
    if (selectedTempUnit == 'Celsius') {
      convertedTemperature = (temperature * 9 / 5) + 32;
      result = '$temperature °C = ${convertedTemperature.toStringAsFixed(2)} °F';
    } else if (selectedTempUnit == 'Fahrenheit') {
      convertedTemperature = (temperature - 32) * 5 / 9;
      result = '$temperature °F = ${convertedTemperature.toStringAsFixed(2)} °C';
    } else {
      convertedTemperature = temperature + 273.15;
      result = '$temperature °C = ${convertedTemperature.toStringAsFixed(2)} K';
    }
    setState(() {});
  }

  void _calculateSDT() {
    // Logic for calculating speed, distance, or time based on selectedSDT
  }

  void _calculateDiscount() {
    double originalPrice = double.parse(originalPriceController.text);
    double discountPercentage = double.parse(discountPercentageController.text);
    double discountAmount = originalPrice * (discountPercentage / 100);
    double finalPrice = originalPrice - discountAmount;
    setState(() {
      result = 'Discounted price is \$${finalPrice.toStringAsFixed(2)}';
    });
  }

  void _calculateFuelEfficiency() {
    double distance = double.parse(distanceController.text);
    double fuelConsumed = double.parse(fuelConsumedController.text);
    double fuelEfficiency = distance / fuelConsumed;
    setState(() {
      result = 'Fuel efficiency is ${fuelEfficiency.toStringAsFixed(2)} km/l';
    });
  }

  void _addTask() {
    setState(() {
      toDoList.add(taskController.text);
      taskController.clear();
    });
  }

  void _removeTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Calculator App'),
        backgroundColor:Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCalculator,
              isExpanded: true,
              items: ['BMI', 'Tip', 'Age', 'Currency', 'Quadratic', 'Temperature', 'SDT', 'Discount', 'Fuel', 'ToDo']
                  .map((calculator) => DropdownMenuItem(
                value: calculator,
                child: Text(calculator),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCalculator = value!;
                });
              },
            ),
            Expanded(child: _buildCalculatorFields()),
            SizedBox(height: 16),
            if (result.isNotEmpty)
              Text(
                result,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              ),
          ],
        ),
      ),
    );
  }
}
