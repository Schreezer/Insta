import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:instagram/Widgets/post_card.dart";
import "package:instagram/utils/colors.dart";

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          // leading: const Icon(Icons.camera_alt_outlined),
          title:
              const Text("Bountier", style: TextStyle(fontFamily: "jokerman")),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline_rounded),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          },
        ));
  }
}
