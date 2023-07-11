import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/screens/about_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';

import '../responsive/moblie_screen_layout.dart';
import '../responsive/web_screen_layout.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<String> texts = [
    'Stuck at Something? \n Want to resolve something? \n Put a Bounty on it!',
    'So What is Bountier? \n\n',
    'A place where you can trade knowledge, seek help, help others, all in exchange for the native currency BNT',
    "Try the Beta version of the App now! and see what it's all about!\n\n Just click the Sign Up button below!"
  ];
  final List<Color> colors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.grey,
    
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      int? nextPage = _pageController.page?.round();
      if (nextPage != null && _currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      PageView.builder(
        controller: _pageController,
        itemCount: texts.length,
        scrollDirection: Axis.vertical,
        // width > 600 ? Axis.vertical : Axis.horizontal,
        itemBuilder: (context, index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: colors[index % 4],
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentPage == index
                          ? Center(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    texts[index],
                                    textAlign: TextAlign.center,
                                    textStyle: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.none, // Remove underline
                                    ),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                repeatForever: false,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                                onTap: () {
                                  print('Text pressed');
                                },
                                onFinished: () {
                                  print('Animation finished');
                                },
                                isRepeatingAnimation: false,
                              ),
                            )
                          : Text(
                              texts[index],
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                decoration: TextDecoration.none, // Remove underline
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      Column(
        children: [
          Expanded(
            flex: (height * 0.5).toInt(),
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.2,
              vertical: height * 0.1,
            ),
            child: width > 600
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResponsiveLayout(
                                  mobileScreenLayout: MobileScreenLayout(),
                                  webScreenLayout: WebScreenLayout(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Take a Peek',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.1),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up or Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResponsiveLayout(
                                      mobileScreenLayout: MobileScreenLayout(),
                                      webScreenLayout: WebScreenLayout(),
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 30),
                        ),
                        child: const Text(
                          'Take a Peek',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 30),
                        ),
                        child: const Text(
                          'Login / Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      Positioned(
        top: 30,
        right: 30,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const aboutScreen(),
            ),
          ),
          child: const Text("About", style: TextStyle(color: Colors.white)),
        ),
      ),
    ]);
  }
}
