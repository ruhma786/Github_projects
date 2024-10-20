import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ModernLudoGame());
}

class ModernLudoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Ludo Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Arial',
      ),
      home: ModernLudoGameScreen(),
    );
  }
}

class ModernLudoGameScreen extends StatefulWidget {
  @override
  _ModernLudoGameScreenState createState() => _ModernLudoGameScreenState();
}

class Player {
  String name;
  int score = 0;
  Player(this.name);
}

class _ModernLudoGameScreenState extends State<ModernLudoGameScreen>
    with SingleTickerProviderStateMixin {
  List<Player> players = [
    Player('Player A'),
    Player('Player B'),
    Player('Player C'),
    Player('Player D'),
  ];

  int currentPlayerIndex = 0;
  int totalRounds = 8;
  int currentRound = 1;
  Random random = Random();
  String message = 'Let’s start rolling!';
  int diceRoll = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    _controller.forward(from: 0); // Start animation

    setState(() {
      diceRoll = random.nextInt(6) + 1;
      players[currentPlayerIndex].score += diceRoll;

      message = '${players[currentPlayerIndex].name} rolled a $diceRoll';

      if (diceRoll == 6) {
        message += ' and gets a bonus roll!';
        return; // Same player gets another turn
      }

      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;

      if (currentPlayerIndex == 0) {
        currentRound++;
      }

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
        title: Text('Game Over!', style: TextStyle(color: Colors.teal)),
        content: Text(
          '${winner.name} is the champion with ${winner.score} points!',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text('Restart'),
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
      message = 'Game restarted! Roll the dice!';
      diceRoll = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modern Ludo Dice Game'),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade900],
            center: Alignment(0.1, 0.3),
            radius: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Round $currentRound of $totalRounds',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 20),
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'images/dice-$diceRoll.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyanAccent.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: currentRound > totalRounds ? null : rollDice,
                child: Text('Roll Dice'),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.teal.shade400,
                      child: ListTile(
                        title: Text(
                          players[index].name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        trailing: Text(
                          '${players[index].score}',
                          style: TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
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
