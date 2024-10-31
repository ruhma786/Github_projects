import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}

class TaskProvider with ChangeNotifier {
  late Database _database;
  List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dueDate TEXT, isCompleted INTEGER)",
        );
      },
      version: 1,
    );
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    final List<Map<String, dynamic>> maps = await _database.query('tasks');
    _tasks = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        dueDate: maps[i]['dueDate'],
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _database.insert('tasks', task.toMap());
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _database.update('tasks', task.toMap(), where: "id = ?", whereArgs: [task.id]);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _database.delete('tasks', where: "id = ?", whereArgs: [id]);
    fetchTasks();
  }

  Future<void> markAsCompleted(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: true,
    );
    await updateTask(updatedTask);
  }
}
