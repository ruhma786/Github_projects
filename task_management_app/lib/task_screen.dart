import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'add_task_screen.dart';
import 'task.dart';
import 'theme_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'edit_task_screen.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    _requestStoragePermission();

    Future<void> _saveTasksToCSV(BuildContext context) async {
      await _requestStoragePermission();
      Directory? directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/tasks.csv';
      print(filePath);

      List<List<dynamic>> rows = [];
      rows.add(['Title', 'Description', 'Is Completed']);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      for (var task in taskProvider.tasks) {
        rows.add([task.title, task.description, task.isCompleted ? 'Completed' : 'Pending']);
      }

      String csvData = const ListToCsvConverter().convert(rows);
      File file = File(filePath);
      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasks exported to $filePath'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Management App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            onPressed: () async {
              await _saveTasksToCSV(context);
            },
            icon: Icon(Icons.save_alt),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Text(
                'No Tasks Available',
                style: TextStyle(
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return TaskCard(task: task);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        child: Icon(Icons.add, size: 30, color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task});

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
      shadowColor: Colors.grey,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            if (!task.isCompleted)
              Text(
                'Time Remaining: ${formatDuration(task.timeRemaining)}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                taskProvider.toggleCompletionStatus(task.id!, value!);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                taskProvider.deleteTask(task.id!);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                taskProvider.editTask(task.id!);
              },
            ),

          ],
        ),
        onLongPress: () {
          taskProvider.deleteTask(task.id!);
        },
      ),
    );
  }
}