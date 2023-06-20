import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/moblie_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/landing_scree.dart';
import 'package:instagram/screens/phone_login.dart';
import 'package:instagram/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await dotenv.load(fileName: "../.env");
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: dotenv.env['apiKey'] ?? '',
      appId: dotenv.env['appId'] ?? '',
      messagingSenderId: dotenv.env['measurementId'] ?? '',
      projectId: dotenv.env['projectId'] ?? '',
      storageBucket: dotenv.env['storageBucket'] ?? '',
    ));
    print("web part ran");
  } else {
    await Firebase.initializeApp();
    print("mobile part ran");
  }
  if (Firebase.apps.isEmpty) {
    print("Firebase initialization failed");
  } else {
    print(Firebase.apps.length);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: 
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          
          theme: ThemeData.dark().copyWith(
            
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                print("snapshot has data: ${snapshot.hasData}");
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              }
              return const LandingScreen();
            },
          )
      )
      ,
    );
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async{
  
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Phone Auth Demo')),
//         body: PhoneAuth(),
//       ),
//     );
//   }
// }

// class PhoneAuth extends StatefulWidget {
//   @override
//   _PhoneAuthState createState() => _PhoneAuthState();
// }

// class _PhoneAuthState extends State<PhoneAuth> {
  
//   final _formKey = GlobalKey<FormState>();
//   final _phoneNumberController = TextEditingController();
//   final _otpController = TextEditingController();
//   String? _verificationId;

//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _submitPhoneNumber,
//                   child: Text('Send Verification Code'),
//                 ),
//                 TextFormField(
//                   controller: _otpController,
//                   decoration: InputDecoration(labelText: 'Verification Code'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the verification code';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _submitOTP,
//                   child: Text('Verify and Sign In'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _submitPhoneNumber() async {
//     await Firebase.initializeApp();
//     if (true) {
//       try {
//         print("hello");
//         await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: _phoneNumberController.text,
//           verificationCompleted: (PhoneAuthCredential credential) {
//             // Auto-resolution of the OTP, no need for user input
//             _signInWithCredential(credential);
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             // Handle verification failure
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Verification failed: ${e.message}')),
//             );
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             // Save the verification ID to use later
//             setState(() {
//               _verificationId = verificationId;
//             });
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {
//             // Auto-retrieval timeout
//           },
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Verification failed: $e')),
//         );
//       }
//     }
//   }

//   void _submitOTP() async {
//     if (_verificationId != null) {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: _otpController.text,
//       );
//       _signInWithCredential(credential);
//     }
//   }

//   Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
//     try {
//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Signed in as: ${userCredential.user!.phoneNumber}'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign in failed: $e')),
//       );
//     }
//   }
// }