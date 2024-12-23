import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EmailVerficationscreen.dart';
import 'AdminDashboard.dart';

class AdminLoginSignupScreen extends StatefulWidget {
  @override
  _AdminLoginSignupScreenState createState() => _AdminLoginSignupScreenState();
}

class _AdminLoginSignupScreenState extends State<AdminLoginSignupScreen> {
  bool isLogin = true;
  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleAdminLoginSignup() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        if (isLogin) {
          // Admin login process
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          DocumentSnapshot userDoc = await _firestore
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();

          final role = userDoc['role'] ?? 'user';

          if (role != 'admin') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Access denied. Only admins can log in.")),
            );
            return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard(email: email)),
          );
        } else {
          // Admin signup process
          String name = nameController.text.trim();
          String confirmPassword = confirmPasswordController.text.trim();

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Passwords do not match.")),
            );
            return;
          }

          UserCredential userCredential = await _auth
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Set the admin role
          await _firestore.collection('Users').doc(userCredential.user!.uid).set({
            'name': name,
            'email': email,
            'role': 'admin',
            'createdAt': FieldValue.serverTimestamp(),
          });

          await userCredential.user?.sendEmailVerification();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.lightBlue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogin ? "Admin Login" : "Admin Sign Up",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  if (!isLogin)
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value!.isEmpty ? "Please enter your name." : null,
                    ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email.";
                      } else if (!value.endsWith("@cuivehari.edu.pk")) {
                        return "Email must end with @cuivehari.edu.pk.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? "Please enter your password." : null,
                  ),
                  if (!isLogin) ...[
                    SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Please confirm your password." : null,
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleAdminLoginSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isLogin ? "LOGIN" : "SIGN UP",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
