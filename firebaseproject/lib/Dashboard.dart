import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserLoginSingupScreen.dart';
import 'AdminLoginSignupScreen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/assets/cui_logo.jpg', // Replace with the actual path to your logo
                height: 120,
              ),
              SizedBox(height: 24),
              Text(
                'CUI Chat App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade400,
                ),
              ),
              SizedBox(height: 40),
              // User Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Fetch user role
                    bool userExists = await checkRole("user");
                    if (userExists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserLoginSignupScreen(),
                        ),
                      );
                    } else {
                      showSnackbar(context, "User role not found in the database.");
                    }
                  } catch (e) {
                    showSnackbar(context, "Error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue.shade400,
                ),
                child: Text(
                  'User',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              // Admin Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Fetch admin role
                    bool adminExists = await checkRole("admin");
                    if (adminExists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminLoginSignupScreen(),
                        ),
                      );
                    } else {
                      showSnackbar(context, "Admin role not found in the database.");
                    }
                  } catch (e) {
                    showSnackbar(context, "Error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue.shade400,
                ),
                child: Text(
                  'Admin',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to check role in Firestore
  Future<bool> checkRole(String role) async {
    try {
      // Query Firestore for the role
      QuerySnapshot querySnapshot = await _firestore
          .collection('roles') // Ensure you have a 'roles' collection
          .where('role', isEqualTo: role)
          .get();

      // Check if documents exist
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking role: $e");
      return false;
    }
  }

  // Helper function to show SnackBar
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
