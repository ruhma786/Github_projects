import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task.dart';
import 'theme_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;
  List<bool> _selectedDays = List.generate(7, (index) => false); // Days of the week selection

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
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

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      'Your task "$title" is due soon!',
      tz.TZDateTime.from(dateTime, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _showImmediateNotification(String title) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel_id', 'Task Notifications',
      channelDescription: 'Channel for task notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    final platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Task Added!',
      'You\'ve added a new task: $title',
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

    List<int> repeatDays = [];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        repeatDays.add(i);
      }
    }

    final task = Task(
      // id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: dueDateTime,
      repeatDays: repeatDays,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);

    _showImmediateNotification(_titleController.text);
    _scheduleNotification(dueDateTime, _titleController.text);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  _selectedDueDate == null
                      ? 'Choose Due Date'
                      : 'Due Date: ${_selectedDueDate.toString().split(' ')[0]}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                trailing: Icon(Icons.calendar_today, color: isDarkMode ? Colors.white : Colors.black),
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
                title: Text(
                  _selectedTime == null
                      ? 'Choose Time'
                      : 'Time: ${_selectedTime!.format(context)}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                trailing: Icon(Icons.access_time, color: isDarkMode ? Colors.white : Colors.black),
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
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Days of the Week:',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(7, (index) {
                        final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _selectedDays[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _selectedDays[index] = value!;
                                });
                              },
                            ),
                            Text(
                              daysOfWeek[index],
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                            ),
                            SizedBox(width: 8),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
