import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ChatsScreen(),
    GroupsScreen(),
    UserAnnouncementsScreen(),
    SettingsScreen(),
    UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue.shade400,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Chats Screen
class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, color: Colors.blue.shade400),
                ),
                title: Text(chat['name']),
                subtitle: Text(chat['lastMessage']),
                trailing: Icon(Icons.chevron_right, color: Colors.blue.shade400),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(chatId: chat.id, userName: chat['name']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Chat Detail Screen
class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  final String userName;
  ChatDetailScreen({required this.chatId, required this.userName});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['sender']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .add({
                      'text': messageController.text,
                      'sender': 'John Doe', // Replace with current user info
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Groups Screen
class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final groups = snapshot.data!.docs;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group['name']),
                subtitle: Text(group['description']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupScreen()));
        },
        backgroundColor: Colors.blue.shade400,
        child: Icon(Icons.add),
      ),
    );
  }
}

class CreateGroupScreen extends StatelessWidget {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Group Purpose'),
              maxLines: 4,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('groups').add({
                  'name': groupNameController.text,
                  'description': descriptionController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}

// Other screens like UserAnnouncementsScreen, SettingsScreen, and UserProfileScreen can follow a similar integration.
class UserAnnouncementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final announcements = snapshot.data!.docs;
          if (announcements.isEmpty) {
            return Center(
              child: Text(
                'No announcements available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    announcement['text'], // Assumes Firestore has a 'text' field for the announcement.
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings & Notifications'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Chat Notifications'),
            trailing: Switch(
              value: true, // You can fetch this value from Firestore
              onChanged: (value) {
                // Save the updated value to Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc('userId') // Replace with actual user ID
                    .update({'chatNotifications': value});
              },
            ),
          ),
          ListTile(
            title: Text('Group Notifications'),
            trailing: Switch(
              value: true, // Fetch this value from Firestore
              onChanged: (value) {
                // Save the updated value to Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc('userId') // Replace with actual user ID
                    .update({'groupNotifications': value});
              },
            ),
          ),
          ListTile(
            title: Text('Clear Chat History'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Clear all chat history in Firestore
                FirebaseFirestore.instance
                    .collection('chats')
                    .get()
                    .then((snapshot) {
                  for (var doc in snapshot.docs) {
                    doc.reference.delete();
                  }
                });
              },
            ),
          ),
          ListTile(
            title: Text('Logout'),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Perform logout logic
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the currently logged-in user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          backgroundColor: Colors.blue.shade400,
        ),
        body: Center(
          child: Text(
            'No user logged in.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'User profile not found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade400,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  user['name'] ?? 'No name available', // Safeguard for missing 'name'
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Department: ${user['department'] ?? 'No department'}'),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Logout logic
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}