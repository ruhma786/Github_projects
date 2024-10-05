import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipGame());
}

class CoinFlipGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoinFlipScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey, // Dark background color
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // White text by default
        ),
      ),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  String _message = 'Guess head or tail';
  String _result = '';
  int _score = 0;
  bool _isFlipping = false;
  String _coinFace = 'head';
  Random _random = Random();
  int _rounds = 0;
  final int _maxRounds = 5;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showResult();
      }
    });

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  void _flipCoin(String guess) {
    if (_isFlipping || _rounds >= _maxRounds) return;

    setState(() {
      _isFlipping = true;
      _message = 'Flipping the coin...';
      _controller.reset();
      _controller.forward();
    });

    Future.delayed(Duration(seconds: 1), () {
      // Generate a random coin face
      _coinFace = _random.nextBool() ? 'head' : 'tail';
      setState(() {
        _result = _coinFace;
        _rounds++;
      });

      // Show if the guess was correct or wrong after flipping is complete
      if (guess == _coinFace) {
        _score++;
        _message = 'You guessed correctly! It\'s $_coinFace!';  // Correct guess
        print('You guessed correct: $_coinFace');  // Print line for correct guess
      } else {
        _message = 'You guessed wrong! It\'s $_coinFace!';  // Wrong guess
        print('You guessed wrong: $_coinFace');  // Print line for wrong guess
      }

      _isFlipping = false;
    });
  }

  void _showResult() {
    setState(() {
      _message = _result == 'head' ? 'It\'s head!' : 'It\'s tail!';
    });
  }

  void _resetGame() {
    setState(() {
      _score = 0;
      _rounds = 0;
      _message = 'Guess head or tail';
      _result = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Flip Game', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent, // Purple title bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round $_rounds/$_maxRounds',
              style: TextStyle(fontSize: 24, color: Colors.amberAccent), // Amber for round display
            ),
            SizedBox(height: 20),
            RotationTransition(
              turns: _animation,
              child: Image.asset(
                _coinFace == 'head'
                    ? 'images/head.jpeg'
                    : 'images/tail.jpeg',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 30),
            Text(
              _message,
              style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent), // Light blue for message text
            ),
            SizedBox(height: 30),
            if (_rounds < _maxRounds)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _flipCoin('head'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.greenAccent, // Text color
                    ),
                    child: Text('Guess head'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _flipCoin('tail'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.orangeAccent,
                    ),
                    child: Text('Guess tail'),
                  ),
                ],
              ),
            if (_rounds >= _maxRounds)
              Column(
                children: [
                  Text(
                    'Game Over! Your score: $_score',
                    style: TextStyle(fontSize: 24, color: Colors.amber), // Amber for game over message
                  ),
                  ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.pinkAccent,
                    ),
                    child: Text('Play Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}




