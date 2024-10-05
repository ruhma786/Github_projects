import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(LudoGame());
}

class LudoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LudoGameScreen(),
    );
  }
}

class LudoGameScreen extends StatefulWidget {
  @override
  _LudoGameScreenState createState() => _LudoGameScreenState();
}

class Player {
  String name;
  int score = 0;
  Player(this.name);
}

class _LudoGameScreenState extends State<LudoGameScreen>
    with SingleTickerProviderStateMixin {
  List<Player> players = [
    Player('Player 1'),
    Player('Player 2'),
    Player('Player 3'),
    Player('Player 4'),
  ];

  int currentPlayerIndex = 0;
  int totalRounds = 10;
  int currentRound = 1;
  Random random = Random();
  String message = '';
  int diceRoll = 0; // Initialize to show dice face 0 at the start

  // Animation variables
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    _controller.forward(from: 0); // Trigger the animation

    setState(() {
      diceRoll = random.nextInt(6) + 1;
      players[currentPlayerIndex].score += diceRoll;

      message = '${players[currentPlayerIndex].name} rolled a $diceRoll';

      if (diceRoll == 6) {
        message += ' and gets an extra roll!';
        // Same player gets another turn
        return;
      }

      // Move to the next player's turn
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;

      // Check if round is complete (i.e., all players rolled once)
      if (currentPlayerIndex == 0) {
        currentRound++;
      }

      // End the game after the set number of rounds
      if (currentRound > totalRounds) {
        _showWinner();
      }
    });
  }

  void _showWinner() {
    Player winner = players.reduce((a, b) => a.score > b.score ? a : b);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('${winner.name} wins with ${winner.score} points!'),
        actions: [
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      currentRound = 1;
      currentPlayerIndex = 0;
      players.forEach((player) => player.score = 0);
      message = 'Game reset! Let\'s start again!';
      diceRoll = 0; // Reset dice roll to 1 (matching image assets)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ludo Dice Game',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Round $currentRound of $totalRounds',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'images/dice-$diceRoll.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: currentRound > totalRounds ? null : rollDice,
                child: Text(
                  'Roll Dice',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '${players[index].name}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      trailing: Text(
                        '${players[index].score}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




