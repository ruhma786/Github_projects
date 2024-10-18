import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz App',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('image/QUIZ APP.jpg', height: 150), // Placeholder for the logo
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectSubjectScreen()),
                );
              },
              child: Text('Start Playing', style: TextStyle(fontSize: 18,color: Colors.white) ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectSubjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('Select Subject'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _navigateToQuizType(context, 'English');
              },
              child: Text('English', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _navigateToQuizType(context, 'Programming');
              },
              child: Text('Programming', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _navigateToQuizType(context, 'History');
              },
              child: Text('History', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToQuizType(BuildContext context, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectQuizTypeScreen(subject: subject),
      ),
    );
  }
}

class SelectQuizTypeScreen extends StatelessWidget {
  final String subject;
  SelectQuizTypeScreen({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('Select Quiz Type'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(subject: subject, quizType: 'Multiple Choice'),
                  ),
                );
              },
              child: Text('Multiple Choice', style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(subject: subject, quizType: 'True/False'),
                  ),
                );
              },
              child: Text('True/False', style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String subject;
  final String quizType;

  QuizScreen({required this.subject, required this.quizType});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, Object>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  Timer? _timer;
  int _timeLeft = 5;

  @override
  void initState() {
    super.initState();
    _questions = _getQuestions(widget.subject, widget.quizType);
    _startTimer();
  }

  List<Map<String, Object>> _getQuestions(String subject, String quizType) {
    Map<String, List<Map<String, Object>>> questions = {
      'English': [
        {'questionText': 'The sky is blue.', 'answer': true},
        {'questionText': 'Cats can fly.', 'answer': false},
        {'questionText': 'Fish live on land.', 'answer': false},
        {'questionText': 'Flutter is a programming language.', 'answer': false},
        {'questionText': 'Earth is the third planet from the sun.', 'answer': true},
      ],
      'Programming': [
        {'questionText': 'Flutter uses Dart.', 'answer': true},
        {'questionText': 'Java is used in Flutter.', 'answer': false},
        {'questionText': 'Python is a compiled language.', 'answer': false},
        {'questionText': 'HTML is a backend language.', 'answer': false},
        {'questionText': 'React is a programming language.', 'answer': false},
      ],
      'History': [
        {'questionText': 'World War I started in 1914.', 'answer': true},
        {'questionText': 'The Eiffel Tower is in Italy.', 'answer': false},
        {'questionText': 'The Great Wall of China is in Japan.', 'answer': false},
        {'questionText': 'Christopher Columbus discovered America.', 'answer': true},
        {'questionText': 'World War II ended in 1945.', 'answer': true},
      ],
    };

    return quizType == 'Multiple Choice'
        ? questions[subject]!.map((q) {
      return {
        'questionText': q['questionText'] as String,
        'options': ['True', 'False'],
        'answer': q['answer'] as bool,
      };
    }).toList()
        : questions[subject]!.map((q) {
      return {
        'questionText': q['questionText'] as String,
        'answer': q['answer'] as bool,
      };
    }).toList();
  }

  void _startTimer() {
    _timeLeft = 5;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _checkAnswer(null);
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _checkAnswer(bool? userAnswer) {
    if (_isAnswered) return;

    _stopTimer();
    bool correctAnswer = _questions[_currentQuestionIndex]['answer'] as bool;

    setState(() {
      _isAnswered = true;
      if (userAnswer == correctAnswer) {
        _score++;
        _isCorrect = true;
      } else {
        _isCorrect = false;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startTimer();
      } else {
        _stopTimer();
        _showResultPage();
      }
    });
  }

  void _showResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(score: _score, totalQuestions: _questions.length),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text('Quiz: ${widget.subject} (${widget.quizType})'),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _questions[_currentQuestionIndex]['questionText'] as String,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (widget.quizType == 'Multiple Choice')
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                    child: Text('True'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                    child: Text('False'),
                  ),
                ],
              ),
            if (widget.quizType == 'True/False')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                    child: Text('True', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                    child: Text('False' , style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Text('Time left: $_timeLeft sec', style: TextStyle(fontSize: 18)),
            if (_isAnswered)
              Text(
                _isCorrect ? 'Correct!' : 'Wrong!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _isCorrect ? Colors.green : Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    double percentage = (score / totalQuestions) * 100;
    String comment;

    if (percentage >= 80) {
      comment = 'Great job!';
    } else if (percentage >= 60) {
      comment = 'Well done!';
    } else {
      comment = 'Good effort, but try again!';
    }

    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text('Quiz Result'),
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You scored $score out of $totalQuestions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              comment,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
              ),
              child: Text('Go Back to Home', style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
