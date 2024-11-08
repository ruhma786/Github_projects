import 'repeat_interval.dart';
import 'dart:convert';// Assuming CustomRepeatInterval is defined in this file.
// class Subtask {
//   String title;
//   bool isCompleted;
//
//   Subtask({required this.title, this.isCompleted = false});
//
//   // Convert Subtask to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'isCompleted': isCompleted ? 1 : 0,
//     };
//   }
//
//   // Convert map to Subtask
//   factory Subtask.fromMap(Map<String, dynamic> map) {
//     return Subtask(
//       title: map['title'],
//       isCompleted: map['isCompleted'] == 1,
//     );
//   }
// }

class Task {
  int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  bool isCompleted;
  final CustomRepeatInterval repeatInterval;
  Duration timeRemaining;
  final List<int> repeatDays; // List to store days the task repeats
  bool notificationScheduled;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.notificationScheduled = false,
    this.repeatInterval = CustomRepeatInterval.none,
    required this.repeatDays,
  }) : timeRemaining = dueDate.difference(DateTime.now());


  // Convert Task to a map for database storage (No subtasks)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeatInterval': repeatInterval.index,
      'repeatDays': repeatDays.join(','), // Store as comma-separated values
    };
  }

  // Convert map to Task (No subtasks)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      repeatInterval: CustomRepeatInterval.values[map['repeatInterval']],
      repeatDays: (map['repeatDays'] as String)
          .split(',')
          .where((day) => day.isNotEmpty) // Only parse non-empty strings
          .map((day) => int.tryParse(day) ?? -1) // Use -1 or another default if parsing fails
          .toList(),
    );
  }


  // Update time remaining based on current time
  void updateTimeRemaining() {
    timeRemaining = dueDate.difference(DateTime.now());
  }

  // Calculate progress based on subtasks


  // Get the next due date based on repeat interval
  DateTime getNextDueDate() {
    DateTime nextDueDate = dueDate;
    switch (repeatInterval) {
      case CustomRepeatInterval.daily:
        nextDueDate = nextDueDate.add(Duration(days: 1));
        break;
      case CustomRepeatInterval.weekly:
        nextDueDate = nextDueDate.add(Duration(days: 7));
        break;
      case CustomRepeatInterval.none:
      default:
        return nextDueDate;
    }
    return nextDueDate;
  }
}

