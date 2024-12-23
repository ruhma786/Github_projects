import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.endsWith('@cuivehari.edu.pk')) {
      return 'Invalid email domain. Use @cuivehari.edu.pk';
    }
    return null;
  }

  void sendPasswordResetEmail() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      // Simulate sending a password reset email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'A password reset link has been sent to $email. Please check your email.'),
        ),
      );
      // Reset email logic (e.g., Firebase or custom backend)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email to receive a password reset link:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: validateEmail,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'SEND RESET LINK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
