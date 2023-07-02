import "package:flutter/material.dart";

class favouriteScreen extends StatelessWidget {
  const favouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return 
     const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Let me know what do you want to see here!"),
        ),
      ),  
    );
  }
}