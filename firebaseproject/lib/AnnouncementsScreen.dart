import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Announcements'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Create Announcement Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAnnouncementScreen()),
                );
              },
              child: Text('Create Announcement'),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('Announcements').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var announcements = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    var announcement = announcements[index];
                    return ListTile(
                      title: Text(announcement['title']),
                      subtitle: Text(announcement['content']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navigate to Edit Announcement Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAnnouncementScreen(
                                    id: announcement.id,
                                    title: announcement['title'],
                                    content: announcement['content'],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              // Delete the announcement from Firestore
                              await _firestore
                                  .collection('Announcements')
                                  .doc(announcement.id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAnnouncementScreen extends StatefulWidget {
  @override
  _CreateAnnouncementScreenState createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Announcement'),
        backgroundColor: Colors.blue.shade400,
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
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
            ElevatedButton(
              onPressed: () async {
                // Add new announcement to Firestore
                await _firestore.collection('Announcements').add({
                  'title': titleController.text,
                  'content': contentController.text,
                });
                Navigator.pop(context); // Go back to the announcements list
              },
              child: Text('Post Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAnnouncementScreen extends StatefulWidget {
  final String id;
  final String title;
  final String content;

  EditAnnouncementScreen({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  _EditAnnouncementScreenState createState() =>
      _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Announcement'),
        backgroundColor: Colors.blue.shade400,
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
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the announcement in Firestore
                await _firestore
                    .collection('Announcements')
                    .doc(widget.id)
                    .update({
                  'title': titleController.text,
                  'content': contentController.text,
                });
                Navigator.pop(context); // Go back to the announcements list
              },
              child: Text('Update Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
