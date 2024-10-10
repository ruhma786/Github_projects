import 'quiz.dart';
class QuizBrain {
  int _questionIndex = 0;
  List<Quiz> _questionBank = [
    Quiz(questionText: 'Flutter is a framework?', answer: true),
    Quiz(questionText: 'Flutter uses Dart language?', answer: true),
    Quiz(questionText: 'Is this web lab?', answer: false),
    Quiz(questionText: "is it laptop?", answer: true),
    Quiz(questionText: 'Flutter is a framework?', answer: true),
    Quiz(questionText: 'Flutter uses c++ language?', answer: false),
    Quiz(questionText: "is it mobile?", answer: false),
    Quiz(questionText: 'Flutter uses Dart language?', answer: true),
    Quiz(questionText: "is flutter running correctly?", answer: true),
    Quiz(questionText: "is flutter a software?", answer: true),
    // Add 8 more questions here
  ];
  String getQuestion() {
    return _questionBank[_questionIndex].questionText;
  }
  bool getAnswer() {
    return _questionBank[_questionIndex].answer;
  }
  void nextQuestion() {
    if (_questionIndex < _questionBank.length - 1) {
      _questionIndex++;
    }
  }
  bool isFinished() {
    return _questionIndex >= _questionBank.length - 1;
  }
  void reset() {
    _questionIndex = 0;
  }
}