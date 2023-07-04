import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _formKey = GlobalKey<FormState>();
  late PageController _pageController;
  int _currentPage = 0;

  final List<String> texts = [
    'Welcome to BOUNTIER',
    'So What is Bountier? \n\n',
    'A place where you can trade knowledge',
  ];
  final List<Color> colors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PageView.builder(
      controller: _pageController,
      itemCount: texts.length,
      scrollDirection: width > 600 ? Axis.vertical : Axis.horizontal,
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors[index % 3],
          ),
          child: Stack(
            children: [
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
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Enter',
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _currentPage == index
                            ? AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    texts[index],
                                    textStyle: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                              )
                            : Text(
                                texts[index],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
