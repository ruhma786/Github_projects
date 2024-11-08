import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'task.dart';
import 'db_helper.dart';
import 'repeat_interval.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pdf_generator.dart';  // Import the PDF Generator

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  bool _isLoading = false;
  Timer? _timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final DBHelper _dbHelper = DBHelper();

  TaskProvider() {
    initializeNotifications();
    loadTasksFromDatabase();
    startTimers();
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> loadTasksFromDatabase() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _dbHelper.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(Task task) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id',
        'Task Notifications',
        channelDescription: 'Notifications for tasks due soon',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    if (!task.isCompleted && task.timeRemaining.inMinutes <= 2 && !task.notificationScheduled) {
      await flutterLocalNotificationsPlugin.show(
        task.id!,
        "Task Reminder",
        'Your task "${task.title}" is due soon!',
        notificationDetails,
      );
      task.notificationScheduled = true;
      await _dbHelper.updateTask(task);
    }
  }

  void startTimers() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      for (var task in _tasks) {
        if (!task.isCompleted) {
          task.updateTimeRemaining();
          if (task.timeRemaining.inSeconds <= 120) {
            scheduleNotification(task);
          }
          if (task.timeRemaining.isNegative && task.repeatInterval == CustomRepeatInterval.none) {
            task.isCompleted = true;
            task.notificationScheduled = false;
            _dbHelper.updateTask(task);
          }
        }
      }
      notifyListeners();
    });
  }

  Future<void> addTask(Task task) async {
    task.id = await _dbHelper.insertTask(task); // Insert the task into the database
    _tasks.add(task); // Add the task to the list

    // Generate a PDF for the task
    await PDFGenerator.generatePDF(task);

    scheduleNotification(task); // Schedule notification for the task
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> markAsCompleted(Task task) async {
    task.isCompleted = true;
    flutterLocalNotificationsPlugin.cancel(task.id!);
    await _dbHelper.updateTask(task);
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    flutterLocalNotificationsPlugin.cancel(id);
    await _dbHelper.deleteTask(id);
    notifyListeners();
  }

  Future<void> editTask(int taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    // Navigate to edit screen or make updates as needed
    notifyListeners();
  }

  Future<void> markTaskAsCompleted(int taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    task.isCompleted = true;
    await _dbHelper.updateTask(task);
    notifyListeners();
  }

  // Get tasks that are due today
  List<Task> getTodayTasks() {
    DateTime today = DateTime.now();
    return _tasks.where((task) {
      return task.dueDate.year == today.year &&
          task.dueDate.month == today.month &&
          task.dueDate.day == today.day;
    }).toList();
  }

  // Get completed tasks
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  // Get repeated tasks
  List<Task> getRepeatedTasks() {
    int todayDayIndex = DateTime.now().weekday - 1;
    return _tasks.where((task) => task.repeatDays.contains(todayDayIndex)).toList();
  }

  // Toggle completion status of a task
  Future<void> toggleCompletionStatus(int taskId, bool isCompleted) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    task.isCompleted = isCompleted;
    if (isCompleted) {
      flutterLocalNotificationsPlugin.cancel(taskId); // Cancel notification if task is completed
    } else {
      scheduleNotification(task); // Reschedule notification if task is not completed
    }
    await _dbHelper.updateTask(task); // Update task in database
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isLoading => _isLoading;
}
