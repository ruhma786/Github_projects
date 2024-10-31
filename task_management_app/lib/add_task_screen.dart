import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.teal[700]),
                filled: true,
                fillColor: Colors.teal[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.teal[700]),
                filled: true,
                fillColor: Colors.teal[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: Colors.teal[700]),
                filled: true,
                fillColor: Colors.teal[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dueDate: _dueDateController.text,
                );
                Provider.of<TaskProvider>(context, listen: false).addTask(task);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
