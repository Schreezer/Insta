import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/comment_card.dart';
import "package:instagram/resources/auth_methos.dart";
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/follow_button.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import '../Widgets/post_card.dart';
import '../utils/global_variables.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var userData;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int tokens = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 2, vsync: this);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data();
      followers = userData['followers'].length;
      following = userData['following'].length;
      tokens = userData['tokens'];
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser?.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchComments() async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    QuerySnapshot querySnapshot = await posts.get();
    List<Future<Map<String, dynamic>>> commentQueries = [];

    for (var post in querySnapshot.docs) {
      CollectionReference? comments = posts.doc(post.id).collection('comments');
      if (comments != null) {
        print("comments: $comments");
        print("post.id: ${post.id}");
        commentQueries.add(comments
            .where('uid', isEqualTo: widget.uid)
            .get()
            .then((querySnapshot) => {
                  'postId': post.id,
                  'comment': querySnapshot,
                }));
      } else {
        print("here the shit was null");
      }
    }

    print("commentQueries: $commentQueries");
    return Future.wait(commentQueries);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['userName'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'BNT Tokens Available: ${tokens.toString()}',
                                  ),
                                ),
                                if (FirebaseAuth.instance.currentUser != null &&
                                    FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid)
                                  FollowButton(
                                    text: 'Sign Out',
                                    backgroundColor: mobileBackgroundColor,
                                    textColor: primaryColor,
                                    borderColor: Colors.grey,
                                    function: () async {
                                      await AuthMethods().signOut();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                  )
                                // else if (FirebaseAuth.instance.currentUser != null)
                                //   isFollowing
                                //       ? FollowButton(
                                //           text: 'Unfollow',
                                //           backgroundColor: Colors.white,
                                //           textColor: Colors.black,
                                //           borderColor: Colors.grey,
                                //           function: () async {
                                //             await FirestoreMethods().followUser(
                                //               FirebaseAuth.instance.currentUser!.uid,
                                //               userData['uid'],
                                //             );

                                //             setState(() {
                                //               isFollowing = false;
                                //               followers--;
                                //             });
                                //           },
                                //         )
                                //       : FollowButton(
                                //           text: 'Follow',
                                //           backgroundColor: Colors.blue,
                                //           textColor: Colors.white,
                                //           borderColor: Colors.blue,
                                //           function: () async {
                                //             await FirestoreMethods().followUser(
                                //               FirebaseAuth.instance.currentUser!.uid,
                                //               userData['uid'],
                                //             );

                                //             setState(() {
                                //               isFollowing = true;
                                //               followers++;
                                //             });
                                //           },
                                //         ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['userName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.grey,
                ),
                // Center(
                //   child: Text("Your Posts"),
                // ),
                TabBar(
                  tabs: const <Widget>[
                    Tab(
                      text: 'Your Bounties',
                    ),
                    Tab(
                      text: 'Your Comments',
                    ),
                  ],
                  controller: _tabController,
                ),

                // TabBarView

                SizedBox(
                  //height so that the remaining window is covered in full
                  height: MediaQuery.of(context).size.height * 0.605,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Center(
                        // For displaying the posts of the user
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .where('uid', isEqualTo: widget.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            // Future.delayed(Duration(seconds: 3), () {
                            //   print(snapshot.connectionState);
                            // });
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            print(
                                "the lwngth of the number of posts of the current user is: ${snapshot.data!.docs.length}");

                            return ListView.builder(
                              shrinkWrap: false,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: width > webScreenSize ? 15 : 0,
                                  horizontal:
                                      width > webScreenSize ? width * 0.3 : 0,
                                ),
                                child: PostCard(
                                  snap: snapshot.data!.docs[index].data(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchComments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              QuerySnapshot querySnapshot =
                                  snapshot.data![index]['comment'];
                              List<CommentCard> commentCards =
                                  querySnapshot.docs.map((doc) {
                                return CommentCard(
                                    commentSnap: doc,
                                    post: FirestoreMethods().getPost(
                                        snapshot.data![index]['postId']));
                              }).toList();
                              return Column(children: commentCards);
                            },
                          );
                        },
                      )),
                    ],
                  ),
                ),

                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('posts')
                //       .where('uid', isEqualTo: widget.uid)
                //       .get(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     return
                //     GridView.builder(
                //       shrinkWrap: true,
                //       itemCount: snapshot.data?.docs.length,
                //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         crossAxisSpacing: 5,
                //         mainAxisSpacing: 1.5,
                //         childAspectRatio: 1,
                //       ),
                //       itemBuilder: (context, index) {
                //         DocumentSnapshot snap = snapshot.data!.docs[index];

                //         return Container(
                //           child: Image(
                //             image: NetworkImage(snap['photoUrl']),
                //             fit: BoxFit.cover,
                //           ),
                //         );
                //       },
                //     );
                //   },
                // )
              ],
            ),
          );
  }

  // Column buildStatColumn(int num, String label) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         num.toString(),
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Container(
  //         margin: const EdgeInsets.only(top: 4),
  //         child: Text(
  //           label,
  //           style: const TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
