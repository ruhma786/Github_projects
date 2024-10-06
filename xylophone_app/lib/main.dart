import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customized Xylophone',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customized Xylophone'),
        ),
        body: Xylophone(),
      ),
    );
  }
}

class Xylophone extends StatefulWidget {
  @override
  XylophoneState createState() => XylophoneState();
}

class XylophoneState extends State<Xylophone> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
  List<Color> _keyColors = List<Color>.generate(7, (index) => Colors.accents[index * 2]);

  // List of available sounds
  List<String> availableSounds = [
    'assets/note1.wav',
    'assets/note2.wav',
    'assets/note3.wav',
    'assets/note4.wav',
    'assets/note5.wav',
    'assets/note6.wav',
    'assets/note7.wav'
  ];

  // List of selected sounds for each key
  late List<String> _keySounds;

  @override
  void initState() {
    super.initState();
    // Initialize each key with a default sound
    _keySounds = List<String>.from(availableSounds);
  }

  Widget buildKey(int keyIndex) {
    return Expanded(
      child: GestureDetector(
        onTap: () => playSound(keyIndex),  // Play the selected sound for the key
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: _keyColors[keyIndex],
          alignment: Alignment.center,
          child: Text(
            'Key ${keyIndex + 1}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  // Play the selected sound for the key
  void playSound(int index) {
    _audioPlayer.play(_keySounds[index]);  // Play the sound from assets
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(7, (index) => buildKey(index)),
          ),
        ),
        settingsPanel(),
      ],
    );
  }

  // Panel to pick colors and sounds for each key
  Widget settingsPanel() {
    return Column(
      children: [
        for (int i = 0; i < 7; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => pickColor(context, i),  // Pick a color for the key
                  child: Text('Color Key ${i + 1}'),
                ),
                DropdownButton<String>(
                  value: _keySounds[i],  // Current selected sound for the key
                  items: availableSounds.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _keySounds[i] = newValue!;  // Update the selected sound for the key
                    });
                  },
                  hint: Text('Select Sound'),  // Show hint text
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Pick a color for the key
  Future<void> pickColor(BuildContext context, int index) async {
    Color pickedColor = _keyColors[index];
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color for key ${index + 1}'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _keyColors[index],
              onColorChanged: (color) => pickedColor = color,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Done'),
              onPressed: () {
                setState(() => _keyColors[index] = pickedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
