import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_firestore/firebase_firestore.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //adding image to firebase storage

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // it is an object that tells about the location of the file

    if (isPost) {
      print("uploading images ");
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask =
        ref.putData(file); // this is simply uploading the file to the location
    TaskSnapshot snap =
        await uploadTask; // this is the snapshot of the file that is uploaded and contains the data regarding the upload process
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> updateTokens(int tokens) async {
  String res = "error";
  try {
    // Get the reference to the user's tokens
    DocumentReference ref = FirebaseFirestore.instance.doc("users/${FirebaseAuth.instance.currentUser!.uid}");
    
    // Update the tokens
    await ref.update({"tokens": tokens});

    // Set the result to success
    res = "success";
  } catch (err) {
    // Set the result to the error message
    res = err.toString();
  }

  // Return the result
  return res;
}

  Future<String> Release_Bounty(bool owner, int amount, String receiver)async{
    
    String res = "error";
    print("storage method for releasing bounty has been called");
    try{
      if(owner){
        // Get the reference to the user's tokens
        DocumentReference ref = FirebaseFirestore.instance.doc("users/${receiver}");
        
        // Update the tokens
        await ref.update({"tokens": FieldValue.increment(amount)});
        // Set the result to success
        res = "success";
        // print("success");
      }
      else{
        // Get the reference to the user's tokens
        res = "request sent";
      }
    } catch (err) {
      // Set the result to the error message
      res = err.toString();
    }
    print(res);
    // Return the result
    return res;
  }

}
