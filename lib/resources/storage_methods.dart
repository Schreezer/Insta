import "dart:typed_data";

import "package:flutter/material.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:uuid/uuid.dart";

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
}
