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
  final commentSnap;
  Future<Post> post;

  CommentCard({Key? key, required this.commentSnap, required this.post})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  FirestoreMethods _firestoreMethods = FirestoreMethods();
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

    Future<void> Release(
        bool toRelease, int Bounty, String uid, String post_id) async {
      if (toRelease == false) {
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
        print("the bounty release function on Comment screen is called");
        if (await StorageMethods().Release_Bounty(toRelease, Bounty, uid) ==
            'success') {
          showSnackBar("Bounty Released", context);
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(post_id)
              .update({
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
                widget.commentSnap.data()['profilePic'],
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
                            uid: widget.commentSnap.data()['uid'],
                          ),
                          // Placeholder(),
                        ),
                      ),
                      child: Text(widget.commentSnap.data()['userName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.commentSnap.data()['datePublished'].toDate(),
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
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 253, 251, 251),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: _isExpanded == false &&
                                widget.commentSnap.data()['text'].length > 200
                            ? widget.commentSnap
                                    .data()['text']
                                    .substring(0, 200) +
                                '...'
                            : widget.commentSnap.data()['text'],
                      ),
                      _isExpanded == false &&
                              widget.commentSnap.data()['text'].length > 200
                          ? TextSpan(
                              text: ' Show More',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : TextSpan(),
                    ],
                  ),
                )),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              child: Text(
                "Attachments: ${widget.commentSnap.data()['pics'].length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                print("i ran");
              },
            ),

            Expanded(child: Container()),
            FutureBuilder<Post>(
              future: widget.post,
              builder: (BuildContext context, AsyncSnapshot<Post> postSnap) {
                // Check if your future has an error
                // print(postSnap.hasData);

                if (postSnap.hasError) {
                  print(postSnap.error);
                  return Text('Error: ${postSnap.error}');
                }

                // Check if your future is still loading
                if (postSnap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // Your future is loaded
                // return Text("data");
                return user != null
                    ? (user.uid == widget.commentSnap.data()['uid']
                        ? ElevatedButton(
                            onPressed: () => Release(
                                postSnap.data!.uid == user.uid,
                                postSnap.data!.bounty,
                                widget.commentSnap.data()['uid'],
                                postSnap.data!.postId),
                            child:
                                // Text("Ask for Bounty, ${postSnap.data!.bounty}"),)
                                Container(child: ( postSnap.data!.uid == user.uid ? Text("Release Bounty"): Text("Raise Issue"))))
                        : postSnap.data!.uid == user.uid
                            ? ElevatedButton(
                                onPressed: () => Release(
                                    postSnap.data!.uid == user.uid,
                                    postSnap.data!.bounty,
                                    widget.commentSnap.data()['uid'],
                                    postSnap.data!.postId),
                                child:
                                    // Text("Ask for Bounty, ${postSnap.data!.bounty}"),
                                    Container(child: Text("Release Bounty")))
                            : Row(children: [
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '${widget.commentSnap.data()['upVotes'].length ?? 0}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        
                                      ),
                                    ),
                                    IconButton(
                                      splashColor: Colors.greenAccent,
                                      splashRadius: 25,
                                      onPressed: () async {
                                        await _firestoreMethods.upVote(
                                          widget.commentSnap
                                              .data()['commentId'],
                                          user.uid,
                                          postSnap.data!.postId,
                                        );
                                      },
                                      icon: Icon(Icons.arrow_upward_rounded),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '${widget.commentSnap.data()['downVotes'].length ?? 0}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      splashColor: Colors.redAccent,
                                      splashRadius: 25,
                                      onPressed: () async {
                                        await _firestoreMethods.downVote(
                                          widget.commentSnap
                                              .data()['commentId'],
                                          user.uid,
                                          postSnap.data!.postId,
                                        );
                                      },
                                      icon: Icon(Icons.arrow_downward_rounded),
                                    ),
                                  ],
                                )
                              ]))
                    : Container();
              },
            ),
          ],
        ),
        _isExpanded
            ?
            // the images in listview builder with side scrolling:
            widget.commentSnap.data()['pics'].length == 0
                ? Container()
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: widget.commentSnap.data()['pics'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => Align(
                          alignment: Alignment.bottomLeft,
                          child: Stack(
                            children: [
                              Container(
                                height: 300,
                                width: 300,
                                child: Image.network(
                                    widget.commentSnap.data()['pics'][index]),
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
            Container(),
      ]),
    );
  }
}
