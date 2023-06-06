import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/moblie_screen_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import env file

void main() async {
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // await Firebase.initializeApp(
    // options: FirebaseOptions(
    // apiKey: dotenv.env['apiKey'] ?? '',
    // appId: dotenv.env['appId'] ?? '',
    // messagingSenderId: dotenv.env['measurementId'] ?? '',
    // projectId: dotenv.env['projectId'] ?? '',
    // )

    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBnpB5N6qkLDPKSp_FlpuSj3lkTXnUvWfE",
      appId: "1:152819163863:web:b9083c5b7ab98b1aa50692",
      messagingSenderId: "152819163863",
      projectId: "instagram-a7218",
      storageBucket: "instagram-a7218.appspot.com"
    ));
    print("web part ran");

  } else {
    await Firebase.initializeApp();
    print("mobile part ran");

  }
    if (Firebase.apps.isEmpty) {
    print("Firebase initialization failed");

  }
  else{
    print(Firebase.apps.length );

  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: SignupScreen(),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ), 
      
    );
  }
}
