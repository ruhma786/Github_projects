// task.dart
import 'repeat_interval.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  bool isCompleted;
  final CustomRepeatInterval repeatInterval;
  Duration timeRemaining;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.repeatInterval = CustomRepeatInterval.none,
  }) : timeRemaining = dueDate.difference(DateTime.now()); // Initialize timeRemaining

  // Update the time remaining based on the current time
  void updateTimeRemaining() {
    timeRemaining = dueDate.difference(DateTime.now());
  }
}
