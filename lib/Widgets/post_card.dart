//Original 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/image_grid.dart';
import 'package:instagram/Widgets/like_animation.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import '../screens/comment_screen.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("i got built again");
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    List<String> images = List<String>.from(widget.snap['photoUrl']);
    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 233, 230, 230).withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bounty Section
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'BOUNTY: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.snap['bounty']} BNT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Poster SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['userName'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user?.uid
                    ? IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showSnackBar(
                              "What the fuck do you want here?", context);
                        }
                        
                        )
                    : Container(),
              ],
            ),
          ),
          // Description Section of the Bounty
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description Row
                Row(
                  children: [
                    Text(
                      "Desciption:",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(208, 57, 239, 230)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      // "hell",
                      style: const TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                isExpanded == false &&
                        widget.snap['description'].toString().length > 200
                    ? GestureDetector(
                        onTap: () => setState(() {
                              isExpanded = !isExpanded;
                            }),
                        child: RichText(
                          text: TextSpan(
                            text: widget.snap['description']
                                .toString()
                                .substring(0, 200),
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Show More...',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ))
                    : Text(widget.snap['description'].toString()),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
 

          widget.snap['photoUrl'].length!=0 ? Text("Attachments: ", style: TextStyle(fontWeight: FontWeight.bold)): Container(),
          isExpanded && widget.snap['photoUrl'].length!=0 ? 
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                print(images[index]);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageFullScreen(
                          images: images,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.1,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.network(
                      images[index],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 10); // change this to the desired width
              },
            ),
          ) : GestureDetector(
            onTap: () => setState(() {
              isExpanded = !isExpanded;
            }),
            child: widget.snap['photoUrl'].length!=0 ? Text( widget.snap['photoUrl'].length.toString() + " images", style: TextStyle(color: Colors.blue),): Container()),

          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user?.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user?.uid)
                      ? const Icon(
                          Icons.thumb_up_sharp,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.thumbs_up_down_outlined,
                        ),
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user!.uid,
                      widget.snap['likes'],
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    postId: widget.snap['postId'].toString(),
                  ),
                )),
              ),
    
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        '${widget.snap['likes'].length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Expanded(child: Container(),),
                  InkWell(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.snap["postId"])
                          .collection("comments")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        // print("snapshot.connectionState");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                              "View all ${snapshot.data!.docs.length} comments");
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                        // Placeholder(),
                      ),
                    ),
                  ),
              
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}