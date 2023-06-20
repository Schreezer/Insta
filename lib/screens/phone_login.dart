import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Phone Auth Demo')),
        body: const PhoneAuth(),
      ),
    );
  }
}

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _otpController = TextEditingController();
  String? _verificationId;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+91xxxxxxxxxx',
              ),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(
              onPressed: _submitPhoneNumber,
              child: const Text('Send Verification Code'),
            ),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _submitOTP,
              child: const Text('Verify and Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          verificationCompleted: (PhoneAuthCredential credential) {
            // Auto-resolution of the OTP, no need for user input
            _signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle verification failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification failed: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            // Save the verification ID to use later
            setState(() {
              _verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-retrieval timeout
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    }
  }

  void _submitOTP() async {
    if (_formKey.currentState!.validate() && _verificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );
      _signInWithCredential(credential);
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as: ${userCredential.user!.phoneNumber}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }
}
