import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/utils.dart';
import 'package:uuid/uuid.dart';
import "../models/comment.dart";
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // deleting post
  Future<void> deletePost(String postId) async {
    try {
      await _fireStore.collection("posts").doc(postId).delete();
    } catch (err) {
      print(err);
    }
  }

  Future<String> uploadPost(
    String description,
    List<Uint8List> file,
    String uid,
    int bounty,
    String userName,
    String profImage,
  ) async {
    String res = "error";
    try {
      List<String> photoUrls = [];
      for (var i = 0; i < file.length; i++) {
        String photoUrl =
            await StorageMethods().uploadImageToStorage("posts", file[i], true);
        photoUrls.add(photoUrl);
      }
      String postId = const Uuid().v1();
      DateTime datePublished = DateTime.now();
      // print(datePublished);
      Post post = Post(
        bounty: bounty,
        description: description,
        userName: userName,
        uid: uid,
        photoUrl: photoUrls,
        postId: postId,
        datePublished: datePublished,
        profImage: profImage,
        likes: [],
      );

      _fireStore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
      print(err);
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
      String postId, // we need to supply the post id, to which the comment will be added
      String text,
      String uid,
      String name, // username of the commentator
      String profilePic, // profile pic of the commentator
      List<Uint8List> pics) async {
    String res = "Some error occurred";
    List<String> pictures = [];
    try {
      print("the length of pics is ${pics.length}");
      for (var i = 0; i < pics.length; i++) {
        print("the length of pics is ${pics.length}");
      
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("comments", pics[i], true);
        print("the photo url is $photoUrl");
        pictures.add(photoUrl);
      }
      print("location is firestore methods, the pics are : $pictures");
      String commentId = const Uuid().v1();
      DateTime datePublished = DateTime.now();
      Comment comm = Comment(
        text: text,
        uid: uid,
        userName: name,
        profilePic: profilePic,
        datePublished: datePublished,
        pics: pictures,
        commentId: commentId,
      );

      if (text.isNotEmpty) {
        _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comm.toJson());

        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

// Follow user

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _fireStore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _fireStore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _fireStore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _fireStore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _fireStore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
