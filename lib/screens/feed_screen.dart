import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:instagram/Widgets/hell.dart";
import "package:instagram/Widgets/post_card.dart";
import "package:instagram/utils/colors.dart";

import "../utils/global_variables.dart";
import "about_screen.dart";

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
        backgroundColor:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webScreenSize
            ? null
            : AppBar(
  backgroundColor: mobileBackgroundColor,
  leading: ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.grey[200], backgroundColor: Colors.grey, // text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const aboutScreen(),
      ),
    ),
    child: const Icon(
      Icons.info_rounded,
      color: Colors.black,
    )
  ),
  title: const Text("Bountier", style: TextStyle(fontFamily: "jokerman")),
  // actions: [
  //   // other actions here
  // ],
),

        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").orderBy("bounty", descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // Future.delayed(Duration(seconds: 3), () {
            //   print(snapshot.connectionState);
            // });
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // print("hello");

            return ListView.builder(
            
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(
                  vertical: width > webScreenSize ? 15 : 0,
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              ),
              
            );
          },
        )
        );
  }
}
