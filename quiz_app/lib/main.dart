import 'package:flutter/material.dart';
import 'dart:async';

class MCQBrain {
  List<Map<String, Object>> _mcqQuestions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Rome', 'Berlin'],
      'answer': 'Paris',
    },
    // Add more MCQs here
  ];

  int _currentQuestionIndex = 0;

  String getQuestion() {
    return _mcqQuestions[_currentQuestionIndex]['question'] as String;
  }

  List<String> getOptions() {
    return _mcqQuestions[_currentQuestionIndex]['options'] as List<String>;
  }

  String getAnswer() {
    return _mcqQuestions[_currentQuestionIndex]['answer'] as String;
  }

  bool isFinished() {
    return _currentQuestionIndex >= _mcqQuestions.length - 1;
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _mcqQuestions.length - 1) {
      _currentQuestionIndex++;
    }
  }

  void reset() {
    _currentQuestionIndex = 0;
  }

  void addQuestion(String question, List<String> options, String answer) {
    _mcqQuestions.add({
      'question': question,
      'options': options,
      'answer': answer,
    });
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < _mcqQuestions.length) {
      _mcqQuestions.removeAt(index);
    }
  }
}

MCQBrain mcqBrain = MCQBrain();


class QuizBrain {
  List<Map<String, Object>> _questions = [
    {'question': 'Flutter is a framework?', 'answer': true},
    {'question': 'Flutter uses Dart language?', 'answer': true},
    {'question': 'A group of lions is called a herd.?', 'answer': false},
    {'question': 'The Pacific Ocean is the largest ocean on Earth.', 'answer': true},
    {'question': 'Bananas grow on trees.', 'answer': false},
    {'question': 'Water boils at 100 degrees Celsius at sea level.', 'answer': true},
    {'question': 'Humans have three lungs.', 'answer': false},
    {'question': 'Flutter uses c++ language?', 'answer': false},
    {'question': 'Sharks are mammals?', 'answer': false},
    {'question': 'Flutter uses Dart language?', 'answer': true},
    {'question': 'Lightning never strikes the same place twice', 'answer': false}
  ];

  int _currentQuestionIndex = 0;

  bool getAnswer() {
    return _questions[_currentQuestionIndex]['answer'] as bool;
  }

  String getQuestion() {
    return _questions[_currentQuestionIndex]['question'] as String;
  }

  bool isFinished() {
    return _currentQuestionIndex >= _questions.length - 1;
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    }
  }

  void reset() {
    _currentQuestionIndex = 0;
  }

  void addQuestion(String question, bool answer) {
    _questions.add({'question': question, 'answer': answer});
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _questions.removeAt(index);
    }
  }

  List<Map<String, Object>> getQuestions() {
    return _questions;
  }
}

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
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrueFalsecreen()), // True/False Quiz Screen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'True/False Question ',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MCQScreen()), // MCQs Section
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'MCQs',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
    _hasAnswered = false;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
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
      _hasAnswered = false;
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
      _hasAnswered = true;
      if (correctAnswer == userPickedAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        score++;
        _isCorrect = true;
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
        _isCorrect = false;
      }
      _timer?.cancel();
      Future.delayed(Duration(milliseconds: 500), _goToNextQuestion);
    });
  }

  void _showDefaultWrongAnswer() {
    setState(() {
      _hasAnswered = true;
      scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      _isCorrect = false;
      _timer?.cancel();
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
      backgroundColor: Colors.pink[200],
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),/////////////////////////////////////
                    backgroundColor: Colors.grey,
                  ),
                ),
                Text(
                  '$_timeRemaining',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,///////////////////////
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
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'True',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _answer(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'False',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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

class TrueFalsecreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()), // MCQs Quiz Screen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Start True False  Quiz',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPanel()), // MCQs Admin Panel
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'TF Admin Panel',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MCQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MCQQuizScreen()), // MCQs Quiz Screen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Start MCQs Quiz',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MCQAdminPanel()), // MCQs Admin Panel
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'MCQs Admin Panel',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MCQQuizScreen extends StatefulWidget {
  @override
  _MCQQuizScreenState createState() => _MCQQuizScreenState();
}

class _MCQQuizScreenState extends State<MCQQuizScreen> {
  int score = 0;
  bool _hasAnswered = false;

  void _answer(String selectedOption) {
    String correctAnswer = mcqBrain.getAnswer();
    setState(() {
      _hasAnswered = true;
      if (selectedOption == correctAnswer) {
        score++;
      }
      Future.delayed(Duration(seconds: 1), () {
        if (mcqBrain.isFinished()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(score: score),
            ),
          );
        } else {
          setState(() {
            mcqBrain.nextQuestion();
            _hasAnswered = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mcqBrain.getQuestion(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: mcqBrain.getOptions().map((option) {
                return ElevatedButton(
                  onPressed: () => _answer(option),
                  child: Text(option),
                );
              }).toList(),
            ),
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
      return 'Bad Performance!';
    } else if (score >= 6 && score <= 8) {
      return 'Average Performance!';
    } else if (score == 9) {
      return 'Good Performance!';
    } else if (score >= 10) {
      return 'Excellence!';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Your score: $score',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                getPerformanceMessage(score),
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  quizBrain.reset();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Restart Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// MCQ Admin Panel
class MCQAdminPanel extends StatefulWidget {
  @override
  _MCQAdminPanelState createState() => _MCQAdminPanelState();
}

class _MCQAdminPanelState extends State<MCQAdminPanel> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
  List.generate(4, (_) => TextEditingController());
  String? _correctAnswer; // Make this nullable to handle unselected state

  @override
  void dispose() {
    _questionController.dispose();
    _optionControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text('MCQs Admin Panel'),
        backgroundColor: Colors.pink[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Enter new question',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: List.generate(4, (index) {
                return TextField(
                  controller: _optionControllers[index],
                  decoration: InputDecoration(
                    hintText: 'Option ${index + 1}',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _correctAnswer,
              hint: Text('Select correct answer'),
              items: _optionControllers
                  .map((controller) => DropdownMenuItem(
                value: controller.text,
                child: Text(controller.text),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value; // Update correct answer
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to save question and options here
                // Example:
                print('Question: ${_questionController.text}');
                print('Options: ${_optionControllers.map((c) => c.text).toList()}');
                print('Correct Answer: $_correctAnswer');
              },
              child: Text('Add Question'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _questionController = TextEditingController();
  bool _answer = true;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.pink[100],////////////////
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Enter new question',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ToggleButtons(
              isSelected: [_answer, !_answer],
              onPressed: (int index) {
                setState(() {
                  _answer = index == 0;
                });
              },
              color: Colors.black, // Color of the unselected text
              selectedColor: Colors.white, // Color of the text when selected
              fillColor: Colors.pinkAccent, // Background color when selected
              borderColor: Colors.white, // Border color
              selectedBorderColor: Colors.pinkAccent, // Border color when selected
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('True'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('False'),
                ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String question = _questionController.text;
                if (question.isNotEmpty) {
                  setState(() {
                    quizBrain.addQuestion(question, _answer);
                    _questionController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Question added successfully'),
                  ));
                }
              },
              child: Text('Add Question',
                style: TextStyle(color: Colors.pink[400], fontSize: 15),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Current Questions:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: quizBrain.getQuestions().length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    child: ListTile(
                      title: Text(
                        quizBrain.getQuestions()[index]['question'] as String,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            quizBrain.removeQuestion(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
