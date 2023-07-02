import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/profile_screen.dart';

class CommentCard extends StatefulWidget {
  final snap;
  Future<Post> post;

  CommentCard({Key? key, required this.snap, required this.post})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
     
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );

    Future<void> Release(bool toRelease, int Bounty, String uid, String post_id) async {
      if(toRelease==false){
        return showSnackBar("The owner will be informed", context);
      }
      bool shouldContinue = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Are you sure you want to release the bounty?'),
                actions: <Widget>[
                  TextButton(
                    style: flatButtonStyle,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    style: flatButtonStyle,
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ) ??
          false;

      if (shouldContinue) {
        if(await StorageMethods().Release_Bounty(toRelease, Bounty, uid)=='success'){
          await FirebaseFirestore.instance.collection('posts').doc(post_id).update({
            'bounty': 0,
            // 'bountyReleased': true,
          });
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.snap.data()['profilePic'],
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: widget.snap.data()['uid'],
                          ),
                        ),
                      ),
                      child: Text(widget.snap.data()['userName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap.data()['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   child: const Icon(
            //     Icons.favorite,
            //     size: 16,
            //   ),
            // )
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                _isExpanded == false && widget.snap.data()['text'].length > 200
                    ? widget.snap.data()['text'].substring(0, 200) +
                        '... Show More'
                    : widget.snap.data()['text'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        _isExpanded
            ?
            // the images in listview builder with side scrolling:

            // covering full screen as height:

            widget.snap.data()['pics'].length == 0
                ? Container()
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: widget.snap.data()['pics'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => Align(
                          alignment: Alignment.bottomLeft,
                          child: Stack(
                            children: [
                              Container(
                                height: 300,
                                width: 300,
                                child: Image.network(
                                    widget.snap.data()['pics'][index]),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => setState(() {
                                    _isExpanded = false;
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
            :
            // Text("much wow"),
            GestureDetector(
                onTap: () => setState(() {
                  _isExpanded = !_isExpanded;
                }),
                child: Row(children: [
                  Text(
                    "Attachments: ${widget.snap.data()['pics'].length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Tester:

                  // Text("well"),

                  FutureBuilder<Post>(
                    future: widget.post,
                    builder:
                        (BuildContext context, AsyncSnapshot<Post> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // return widget informing of error
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // return your Container widget
                          return Container();
                        }
                      } else {
                        // still loading, return loading widget
                        return CircularProgressIndicator();
                      }
                    },
                  ),

                  Expanded(child: Container()),
                  // snappy is the post kinda lika
                  FutureBuilder<Post>(
                    future: widget.post,
                    builder:
                        (BuildContext context, AsyncSnapshot<Post> snappy) {
                      // Check if your future has an error
                      // print(snappy.hasData);

                      if (snappy.hasError) {
                        print(snappy.error);
                        return Text('Error: ${snappy.error}');
                      }

                      // Check if your future is still loading
                      if (snappy.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      // Your future is loaded
                      return ElevatedButton(
                        
                        onPressed: () => Release(snappy.data!.uid == user!.uid,
                            snappy.data!.bounty, widget.snap.data()['uid'], snappy.data!.postId),
                        child:
                            // Text("Ask for Bounty, ${snappy.data!.bounty}"),
                            Text((snappy.data!.uid == user!.uid)
                                ? "Release Bounty"
                                : "Ask for Bounty"),
                      );
                    },
                  ),
                ]),
              )
      ]),
    );
  }
}
