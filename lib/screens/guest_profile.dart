import "package:flutter/material.dart";

import "../utils/colors.dart";
import "login_screen.dart";

class guestProfile extends StatelessWidget {
  const guestProfile({super.key});

  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                "Please Login or Sign up",
              ),
              centerTitle: false,
            ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Please Login or Sign up"),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                );
                  },
                  child: Text("Login or Sign up"),
                ),
              ],
            ),
          ),
    );
  }
}