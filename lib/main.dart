import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/moblie_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/landing_scree.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // await dotenv.load(fileName: "../.env");
    // await Firebase.initializeApp(
    //     options: FirebaseOptions(
    //   apiKey: dotenv.env['apiKey'] ?? '',
    //   appId: dotenv.env['appId'] ?? '',
    //   messagingSenderId: dotenv.env['measurementId'] ?? '',
    //   projectId: dotenv.env['projectId'] ?? '',
    //   storageBucket: dotenv.env['storageBucket'] ?? '',
    // ));

    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyBnpB5N6qkLDPKSp_FlpuSj3lkTXnUvWfE',
      appId: '1:152819163863:web:b9083c5b7ab98b1aa50692',
      messagingSenderId: '152819163863',
      projectId: 'instagram-a7218',
      storageBucket: 'instagram-a7218.appspot.com',
    ));
  } else {
    await Firebase.initializeApp();
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
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: true);

              userProvider.refreshUser(true);
              // print("hello");
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (userProvider.getUser != null) {
                    return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout(),
                    );
                  } else {
                    return const SignupScreen();
                  }
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
          )),
    );
  }
}
