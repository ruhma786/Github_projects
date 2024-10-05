
import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(CoinFlipApp());
}
class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: CoinFlipScreen(),
    );
  }
}
class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}
class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _movementAnimation;
  String coinFace = 'images/head.jpeg'; // Initial image, set to head
  String resultText = ''; // To display heads or tails
  Random random = Random();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration for realistic flip
      vsync: this,
    );
    // Animation for rotation (flips from 0 to 360 degrees)
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    // Animation for vertical movement (up and down)
    _movementAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  void flipCoin() {
    _controller.forward(from: 0).then((_) {
      // Determine the result after animation
      String result = random.nextBool() ? 'head' : 'tail';
      setState(() {
        resultText = result == 'head' ? 'head' : 'tail'; // Update result text
        coinFace = result == 'head' ? 'images/head.jpeg' : 'images/tail.jpeg'; // Set final face
      });
      _controller.reset(); // Reset animation
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
        title: Text('Coin Flip'),
        backgroundColor: Colors.blueGrey, // Title bar color
      ),
      body: Container(
        color: Colors.blueGrey.shade100, // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _movementAnimation.value), // Move up and down
                    child: Transform.rotate(
                      angle: _rotationAnimation.value, // Rotate the coin
                      child: Image.asset(coinFace, width: 80, height: 80),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                resultText,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // Button background color
                ),
                onPressed: flipCoin,
                child: Text('Flip Coin', style: TextStyle(color: Colors.black)), // Button text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}