import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:instagram/resources/storage_methods.dart";
import "../models/user.dart" as model;
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future <model.User> getUserDetails () async {
    User currentUser = _auth.currentUser!;
    print(currentUser);
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return  model.User.fromSnap(snap);
    }
  Future<String> signupUser(
      {required String mail,
      required String password,
      required String bio,
      required String userName,
      required Uint8List file}) async {
    String res = "Some Error Occured";
    try {
      if (mail.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          userName.isNotEmpty) {
        //register new user
        print("registering new user");
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: mail, password: password);
        // add user to database
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profileImage", file, false);
        print(photoUrl);
        model.User user = model.User(
          email: mail,
          uid: cred.user!.uid,
          userName: userName,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "The password is too weak";
      } else if (err.code == "email-already-in-use") {
        res = "The account already exists for that email";
      } else {
        res = err.toString();
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
  //Login part

  Future<String> loginUser({
    required String mail,
    required String password,
  }) async {
    String res = "Some Error Occured";
    try {
      if (mail.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: mail, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }  
    catch (_err) {
      res = _err.toString();
    }
    return res;
  }

  
}
