import 'package:flutter/material.dart';
import 'task.dart';
import 'task_provider.dart';
import 'package:provider/provider.dart';
import 'pdf_generator.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the task's existing data
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    // Dispose controllers to free up memory
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ensure task ID is non-null, then update the task with new details
                if (widget.task.id != null) {
                  taskProvider.editTask(
                    widget.task.id!,
                   // titleController.text,
                   // descriptionController.text,
                  );
                  Navigator.pop(context); // Go back to the task screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task ID is missing!')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                // Ensure task ID is non-null
                if (widget.task.id != null) {
                  await PDFGenerator.generatePDF(widget.task); // Generate PDF
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task ID is missing!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
