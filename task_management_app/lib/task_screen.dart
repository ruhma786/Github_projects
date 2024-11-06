import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'add_task_screen.dart';
import 'task.dart';
import 'db_helper.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Management App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[600],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Text(
                'No Tasks Available',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
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
        backgroundColor: Colors.teal[400],
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}

// TaskCard widget is defined here
class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task});

  // Format the remaining time as hours, minutes, and seconds
  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      color: task.isCompleted ? Colors.green[50] : Colors.white,
      shadowColor: Colors.teal[100],
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
            color: task.isCompleted ? Colors.green[800] : Colors.teal[800],
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            SizedBox(height: 4),
            // Display time remaining if task is not completed
            if (!task.isCompleted)
              Text(
                'Time Remaining: ${formatDuration(task.timeRemaining)}',
                style: TextStyle(color: Colors.red[400], fontSize: 16),
              ),
          ],
        ),
        trailing: task.isCompleted
            ? Icon(Icons.check, color: Colors.green)
            : ElevatedButton(
          onPressed: () => taskProvider.markAsCompleted(task),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[400],
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Complete', style: TextStyle(color: Colors.white)),
        ),
        onLongPress: () {
          if (task.id != null) {
            taskProvider.deleteTask(task.id);
          } else {
            print("Task ID is null. Cannot delete.");
          }
        },
      ),
    );
  }
}
