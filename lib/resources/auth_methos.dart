import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future <String> signupUser({
    required String mail,
    required String password,
    required String bio,
    required String userName,
    // required Uint8List file
  }) async {
    String res = "Some Error Occured";
    try{
      if (mail.isNotEmpty || password.isNotEmpty || bio.isNotEmpty || userName.isNotEmpty  ){
        //register new user
        print("registering new user");
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: mail, password: password);
       // add user to database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'userName':userName,
          'bio': bio,
          'email':mail,
          'uid':cred.user!.uid,
          // 'profileImage':file, 
          'followers':[],
          'following':[],
        });
        res = "success";
      }

    }
    catch (error){
      res = error.toString();

    }
    return res;

  }
}