import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/task_provider.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: task.isCompleted
                    ? Icon(Icons.check, color: Colors.green)
                    : ElevatedButton(
                  onPressed: () => taskProvider.markAsCompleted(task),
                  child: Text('Complete'),
                ),
                onLongPress: () => taskProvider.deleteTask(task.id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
