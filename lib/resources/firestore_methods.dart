import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

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
    Uint8List file,
    String uid,
    String userName,
    String profImage,
  ) async {
    String res = "error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      DateTime datePublished = DateTime.now();
      print(datePublished);
      Post post = Post(
        description: description,
        userName: userName,
        uid: uid,
        photoUrl: photoUrl,
        postId: postId,
        datePublished: datePublished,
        profImage: profImage,
        likes: [],
      );

      _fireStore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
      print (err);
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
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {

        String commentId = const Uuid().v1();
        _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
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

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _fireStore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
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

    } catch(e) {
      print(e.toString());
    }
  }
}