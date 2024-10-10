import 'package:flutter/material.dart';
import 'dart:async';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Set background color
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button background color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Start Quiz',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Icon> scoreKeeper = [];
  int score = 0;
  Timer? _timer;
  int _timeRemaining = 5;
  bool? _isCorrect;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = 5;
    _hasAnswered = false; // Reset the answer flag
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          // If time runs out, consider it a wrong answer if the user hasn't answered yet
          if (!_hasAnswered) {
            _showDefaultWrongAnswer();
          }
        }
      });
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _timeRemaining = 5;
      _isCorrect = null;
      _hasAnswered = false; // Reset the answer flag
      if (quizBrain.isFinished()) {
        _timer?.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      } else {
        quizBrain.nextQuestion();
        _startTimer();
      }
    });
  }

  void _answer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    setState(() {
      _hasAnswered = true; // Set the answer flag
      if (correctAnswer == userPickedAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        score++;
        _isCorrect = true;
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
        _isCorrect = false;
      }
      _timer?.cancel(); // Stop the timer when the user answers
      Future.delayed(Duration(milliseconds: 500), _goToNextQuestion);
    });
  }

  void _showDefaultWrongAnswer() {
    setState(() {
      _hasAnswered = true;
      scoreKeeper.add(Icon(Icons.close, color: Colors.red)); // Add cross mark
      _isCorrect = false;
      _timer?.cancel(); // Stop the timer
      Future.delayed(Duration(milliseconds: 500), _goToNextQuestion);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: Colors.blueAccent, // Set background color
      backgroundColor: Colors.indigo[100], // Light background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _timeRemaining / 5,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Text(
                  '$_timeRemaining',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              quizBrain.getQuestion(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _answer(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button for True
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'True',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _answer(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red button for False
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'False',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scoreKeeper,
            ),
            SizedBox(height: 20),
            _isCorrect == true
                ? Icon(Icons.check, color: Colors.green, size: 40)
                : _isCorrect == false
                ? Icon(Icons.close, color: Colors.red, size: 40)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  String getPerformanceMessage(int score) {
    if (score >= 0 && score <= 5) {
      return 'Bad Performance';
    } else if (score >= 6 && score <= 8) {
      return 'Average Performance';
    } else if (score == 9) {
      return 'Good Performance';
    } else if (score == 10) {
      return 'Excellence';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Set background color
    //  backgroundColor: Colors.tealAccent[100], // Set background color
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quiz Completed!', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Text('Your Score: $score', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text(
                getPerformanceMessage(score),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  quizBrain.reset();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => StartScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Restart Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
