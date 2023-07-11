// import 'dart:ffi';
import 'dart:typed_data';
// import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:intl/date_time_patterns.dart';
// import 'package:instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import '../Widgets/comment_card.dart';
import '../models/post.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  List<Uint8List> upload_images = [];

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a Photo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Photo with Camera"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  
                  upload_images.add(file);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Image from Gallery"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  print("image added from gallery");
                  upload_images.add(file);
                  // _file = file;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void clearImage() {
    print("clearing image");
    setState(() {
      // _file = null;
      upload_images.clear();
    });
  }

  void clearImageAtIndex(int index) {
    setState(() {
      upload_images.removeAt(index);
    });
  }

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
        upload_images,
      );

      if (res != 'success') {
        // ignore: use_build_context_synchronously
        showSnackBar(res, context);
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar('Comment posted successfully', context);
        clearImage();
        setState(() {
          commentEditingController.text = "";
        });
      }
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  Future<Post> fact() async {
    DocumentSnapshot post = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .get();
  
    // print(
        // "here i am speaking from the ocmment_screen, the value of the post is : ${(post.data() as Map<String, dynamic>)['uid']}");
        // print(post.data() as Map<String, dynamic>);
    // var passer = Post(bounty: 10 , description: "helo" , uid: "much wow" , userName: "batm" , postId: "1213" ,photoUrl: ["http://picum.com"] , datePublished: "much wow" , likes:[] ,  profImage: "afwa");
    final passer = Post.fromSnap(post);
  
    return passer;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser ?? null as User?;
    // User? user = null as User?;

    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          else if(snapshot.hasData == false){
            print(snapshot.data!.docs.length);
            print("the length of upload images is:${upload_images.isEmpty} ");
            return const Center(
              child: Text('No comments yet'),
            );
          }
          
          else if (snapshot.data!.docs.length == 0 && upload_images.isEmpty) {
            return const Center(
              child: Text('No comments yet'),
            );
          }
          
          if (upload_images.isEmpty) {
            return 
            ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => CommentCard(
                commentSnap: snapshot.data!.docs[index],
                post: 
                fact(),
                // Future.value(Post(bounty: 10 , description: "helo" , uid: "much wow" , userName: "batm" , postId: "1213" ,photoUrl: ["http://picum.com"] , datePublished: "much wow" , likes:[] ,  profImage: "afwa", comments: [])),
                
              ),
             
                
            );
             // fact(),
          } else {
            return
            //  Text("hello");

            Align(
              alignment: Alignment.bottomLeft,
              child: ListView.builder(
                itemCount: upload_images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => Align(
                  alignment: Alignment.bottomLeft,
                  child: Stack(children: [
                    Container(
                      height: 300,
                      width: 300,
                      child: Image.memory(upload_images[index]),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => clearImageAtIndex(index),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }
        },
      ),
      // text input
      
      bottomNavigationBar: 
      
      SafeArea(
        child:
        user!=null ? Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectImage(context),
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: ()
                => postComment(
                  user.uid,
                  user.userName,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ): Text("Please Login to comment"),
      ) 
      

    );
  }
}
