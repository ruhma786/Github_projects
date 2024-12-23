import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Homescreen.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? countdownTimer;
  int remainingSeconds = 60;
  bool canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startCountdownTimer();
  }

  void startCountdownTimer() {
    setState(() {
      remainingSeconds = 60;
      canResendOtp = false;
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          canResendOtp = true;
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void resendOtp() async {
    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP has been resent to your email.")),
      );
      startCountdownTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend OTP: $e")),
      );
    }
  }

  void verifyOtp() async {
    try {
      User? user = _auth.currentUser;
      await user?.reload();
      if (user?.emailVerified ?? false) {
        // Update Firestore with verification status
        await _firestore
            .collection('Users')
            .doc(user?.uid)
            .update({'isEmailVerified': true});

        // Navigate to Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email not verified. Please check your inbox.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Email Verification",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Please check your email for the OTP. Enter the OTP below to verify your account.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOtp,
              child: Text("Verify"),
            ),
            SizedBox(height: 20),
            Text(
              "Resend OTP in: ${remainingSeconds}s",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (canResendOtp)
              TextButton(
                onPressed: resendOtp,
                child: Text("Resend OTP"),
              ),
          ],
        ),
      ),
    );
  }
}
