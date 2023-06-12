import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/moblie_screen_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import env file

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: LoginScreen(),

          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
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
              return LoginScreen();
            },
          )),
    );
  }
}
