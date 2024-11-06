import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'task.dart';
import 'db_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  Timer? _timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  TaskProvider() {
    initializeNotifications();
    startTimers();
  }

  // Initialize notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule a notification
  Future<void> scheduleNotification(Task task) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for tasks due soon',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Schedule the notification for task's due date
    await flutterLocalNotificationsPlugin.schedule(
      task.id,
      'Task Reminder: ${task.title}',
      task.description,
      task.dueDate,
      notificationDetails,
    );
  }

  // Start timers to update task time remaining and trigger notifications
  void startTimers() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      for (var task in _tasks) {
        if (!task.isCompleted) {
          task.updateTimeRemaining(); // Update time remaining
          if (task.timeRemaining.inSeconds <= 0) {
            scheduleNotification(task); // Trigger notification if time is up
            task.isCompleted = true; // Mark as completed to avoid duplicate notifications
          }
        }
      }
      notifyListeners();
    });
  }

  void addTask(Task task) {
    _tasks.add(task);
    scheduleNotification(task); // Schedule notification on adding a task
    notifyListeners();
  }

  void markAsCompleted(Task task) {
    task.isCompleted = true;
    flutterLocalNotificationsPlugin.cancel(task.id); // Cancel notification
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    flutterLocalNotificationsPlugin.cancel(id); // Cancel notification
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
}
