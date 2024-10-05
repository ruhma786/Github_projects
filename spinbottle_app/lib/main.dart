import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(SpinTheBottleApp());

class SpinTheBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spin The Bottle',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PlayerInputScreen(),
    );
  }
}

// Screen to input player names
class PlayerInputScreen extends StatefulWidget {
  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> playerNames = [];
  String bottleDesign = 'Classic'; // Default bottle design

  // Predefined bottle options
  final List<String> bottles = ['Classic', 'Fancy', 'Rainbow', 'Retro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin The Bottle '),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.green[50], // Light background color
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Enter up to 10 player names:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Player ${index + 1}',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (index < playerNames.length) {
                            playerNames[index] = value;
                          } else if (value.isNotEmpty) {
                            playerNames.add(value);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: bottleDesign,
                items: bottles.map((bottle) {
                  return DropdownMenuItem(
                    value: bottle,
                    child: Text(bottle),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bottleDesign = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Bottle Design',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (playerNames.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpinBottleScreen(
                          players: playerNames.where((name) => name.isNotEmpty).toList(),
                          bottleDesign: bottleDesign,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Start the Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Spin the bottle screen
class SpinBottleScreen extends StatefulWidget {
  final List<String> players;
  final String bottleDesign;

  SpinBottleScreen({required this.players, required this.bottleDesign});

  @override
  _SpinBottleScreenState createState() => _SpinBottleScreenState();
}

class _SpinBottleScreenState extends State<SpinBottleScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final Random _random = Random();
  int _selectedPlayerIndex = -1;
  double _endRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Adjusted spinning duration to 5 seconds
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void spinBottle() {
    setState(() {
      _selectedPlayerIndex = _random.nextInt(widget.players.length);
      _endRotation = _random.nextDouble() * 6; // Randomize rotation (6 represents a full circle)
      _animationController.forward(from: 0.0).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeScreen(
              selectedPlayer: widget.players[_selectedPlayerIndex],
            ),
          ),
        );
      });
    });
  }

  // Helper method to calculate circular positions for player names
  List<Widget> _buildPlayerNamesAroundBottle(Size size) {
    final double radius = 150;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return List.generate(widget.players.length, (index) {
      final angle = (2 * pi * index) / widget.players.length;
      final x = centerX + radius * cos(angle) - 40; // Adjust to center the name
      final y = centerY + radius * sin(angle) - 10;

      return Positioned(
        left: x,
        top: y,
        child: Text(
          widget.players[index],
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin the Bottle'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        color: Colors.green[50], // Background color
        child: Stack(
          children: [
            // Display player names around the bottle
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: _buildPlayerNamesAroundBottle(constraints.biggest),
                );
              },
            ),
            Center(
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: _endRotation).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Image.asset(
                  'assets/${widget.bottleDesign.toLowerCase()}_bottle.jpg',
                  height: 125,
                  width: 125,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: spinBottle,
                child: Text('Spin the Bottle!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Challenge screen
class ChallengeScreen extends StatelessWidget {
  final String selectedPlayer;

  final List<String> predefinedChallenges = [
    'Do 10 push-ups!',
    'Sing a song!',
    'Tell a joke!',
    'Dance for 1 minute!',
    'Share an embarrassing story!',
    'Do a funny dance for 30 seconds!',
    'Speak in an accent (like British, Australian, or Southern) for the next two rounds!',
    'Pretend to be a waiter and take everyone\'s order!',
    'Allow someone to send a random message from your phone!',
    'Eat something without using your hands!',
    'Imitate a famous person for 1 minute!',
    'Make a weird animal sound for 10 seconds!',
    'Balance something on your head for 30 seconds!',
    'Spin around 10 times and try to walk straight!',
    'Post a funny picture of yourself on social media!',
    'Talk in a robot voice for the next round!',
    'Say the alphabet backward as fast as you can!',
    'Laugh uncontrollably for 30 seconds!',
  ];

  ChallengeScreen({required this.selectedPlayer});

  @override
  Widget build(BuildContext context) {
    String randomChallenge =
    predefinedChallenges[Random().nextInt(predefinedChallenges.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedPlayer\'s Turn!'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        color: Colors.green[50], // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$selectedPlayer, your challenge is:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                randomChallenge,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Complete Challenge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
