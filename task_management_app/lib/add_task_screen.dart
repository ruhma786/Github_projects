import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task.dart';
import 'repeat_interval.dart'; // Import custom RepeatInterval

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  RepeatInterval _selectedRepeatInterval = RepeatInterval.none; // Initialize to custom enum

  void _submitTask() {
    if (_titleController.text.isEmpty || _selectedDueDate == null) return;

    final task = Task(
      id: 0, // Temporary ID, will be replaced in addTask method of TaskProvider
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDueDate!,
      repeatInterval: _selectedRepeatInterval,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(_selectedDueDate == null
                  ? 'Choose Due Date'
                  : 'Due Date: ${_selectedDueDate.toString()}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDueDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<RepeatInterval>(
              decoration: InputDecoration(labelText: 'Repeat'),
              value: _selectedRepeatInterval,
              items: [
                DropdownMenuItem(
                  value: RepeatInterval.none,
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: RepeatInterval.daily,
                  child: Text('Daily'),
                ),
                DropdownMenuItem(
                  value: RepeatInterval.weekly,
                  child: Text('Weekly'),
                ),
                DropdownMenuItem(
                  value: RepeatInterval.monthly,
                  child: Text('Monthly'),
                ),
              ],
              onChanged: (RepeatInterval? newValue) {
                setState(() {
                  _selectedRepeatInterval = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
