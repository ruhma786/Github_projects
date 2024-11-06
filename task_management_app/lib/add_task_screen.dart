import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'task_provider.dart';
import 'task.dart';
import 'repeat_interval.dart';
import 'dart:async';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;
  CustomRepeatInterval _selectedRepeatInterval = CustomRepeatInterval.none;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DateTime dateTime, String title) async {
    final androidDetails = AndroidNotificationDetails(
      'task_channel_id', 'Task Notifications',
      channelDescription: 'Channel for task due notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Task Reminder',
      'It\'s time for your task: $title',
      dateTime,
      platformDetails,
    );
  }

  void _submitTask() {
    if (_titleController.text.isEmpty || _selectedDueDate == null || _selectedTime == null) return;

    final dueDateTime = DateTime(
      _selectedDueDate!.year,
      _selectedDueDate!.month,
      _selectedDueDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final task = Task(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: dueDateTime,
      repeatInterval: _selectedRepeatInterval,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);

    _scheduleNotification(dueDateTime, _titleController.text);
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
            ListTile(
              title: Text(_selectedDueDate == null ? 'Choose Due Date' : 'Due Date: ${_selectedDueDate.toString().split(' ')[0]}'),
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
            ListTile(
              title: Text(_selectedTime == null ? 'Choose Time' : 'Time: ${_selectedTime!.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            DropdownButtonFormField<CustomRepeatInterval>(
              decoration: InputDecoration(labelText: 'Repeat'),
              value: _selectedRepeatInterval,
              items: [
                DropdownMenuItem(value: CustomRepeatInterval.none, child: Text('None')),
                DropdownMenuItem(value: CustomRepeatInterval.daily, child: Text('Daily')),
                DropdownMenuItem(value: CustomRepeatInterval.weekly, child: Text('Weekly')),
                DropdownMenuItem(value: CustomRepeatInterval.monthly, child: Text('Monthly')),
              ],
              onChanged: (CustomRepeatInterval? newValue) {
                setState(() {
                  _selectedRepeatInterval = newValue!;
                });
              },
            ),
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
