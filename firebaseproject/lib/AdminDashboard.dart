import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'AnnouncementsScreen.dart'; // Screen for managing announcements

class AdminDashboard extends StatelessWidget {
  final String email;

  AdminDashboard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Logged in as: $email',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.group, color: Colors.blue),
                    title: Text('Manage Users'),
                    subtitle: Text('Add or remove users from the system.'),
                    onTap: () {
                      // Navigate to Manage Users Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageUsersScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.announcement, color: Colors.blue),
                    title: Text('Manage Announcements'),
                    subtitle: Text('Create, edit, or delete announcements.'),
                    onTap: () {
                      // Navigate to the Announcement Management Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.blue),
                    title: Text('System Settings'),
                    subtitle: Text('Configure app settings and preferences.'),
                    onTap: () {
                      // Navigate to System Settings Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SystemSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ManageUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name']), // Assuming a 'name' field exists in Firestore
                subtitle: Text(user['email']), // Assuming an 'email' field exists
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete user from Firestore
                    FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add User Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade400,
      ),
    );
  }
}
class AnnouncementsScreen extends StatelessWidget {
  final TextEditingController announcementController = TextEditingController();

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
            child: TextField(
              controller: announcementController,
              decoration: InputDecoration(
                labelText: 'New Announcement',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add a new announcement to Firestore
              FirebaseFirestore.instance.collection('announcements').add({
                'text': announcementController.text,
                'timestamp': Timestamp.now(),
              });
              announcementController.clear();
            },
            child: Text('Add Announcement'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final announcements = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return ListTile(
                      title: Text(announcement['text']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Delete announcement from Firestore
                          FirebaseFirestore.instance
                              .collection('announcements')
                              .doc(announcement.id)
                              .delete();
                        },
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
class SystemSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Settings'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Center(
        child: Text(
          'System settings will be implemented here.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class AddUserScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New User'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();

                if (name.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Name and Email cannot be empty!')),
                  );
                  return;
                }

                try {
                  // Add user to Firestore
                  await FirebaseFirestore.instance.collection('users').add({
                    'name': name,
                    'email': email,
                    'role': 'user', // Default role
                    'createdAt': Timestamp.now(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User added successfully!')),
                  );

                  Navigator.pop(context); // Return to the previous screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add user: $e')),
                  );
                }
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
