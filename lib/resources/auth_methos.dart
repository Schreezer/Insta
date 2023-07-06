import "dart:async";
import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:instagram/resources/storage_methods.dart";
import "../models/user.dart" as model;
import "../utils/global_variables.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _verificationId = "empty string";

  late UserCredential Cred;

  Future<model.User> getUserDetails() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print("user is null");
        throw "user is null";
      } else {
        DocumentSnapshot snap =
            await _firestore.collection('users').doc(currentUser.uid).get();
        // print("the snap is: ${snap.data()}");
        return model.User.fromSnap(snap);
      }
    } catch (e) {
      // print("shit is null");
      // print(e);
      throw e;
    }
  }

  Future<String> _submitOTP(
    String otp,
    String _verificationid,
  ) async {
    if (_verificationid != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationid,
        smsCode: otp,
      );
      final value = await _signInWithCredential(credential);
      // print("the value of value in _submitOtp funciton is: $value");
      if (value == "success") {
        return "success";
      } else {
        return value;
      }
    } else {
      return "mobile number not submitted";
    }
  }

  Future<String> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      print("registering new user");
      Cred = await _auth.signInWithCredential(credential);
      print("success");
      return ("success");
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signupUser({
    required String mail,
    required String bio,
    required String userName,
    required String phoneNumber,
    Uint8List? file,
    required String uid,
  }) async {
    // print("the uid is $uid");
    // print("the phone number is $phoneNumber");
    String res = "Some Error Occured";
    // print("signning up the user");
    try {
      if (mail.isNotEmpty &&
          bio.isNotEmpty &&
          userName.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        //register new user
        // print("registering new user");
        // UserCredential cred = await _auth.createUserWithEmailAndPassword(
        //     email: mail, password: password);
        // add user to database

        String photoUrl;

        if (file == null) {
          photoUrl =
              'https://cdn.dribbble.com/users/6142/screenshots/5679189/media/1b96ad1f07feee81fa83c877a1e350ce.png?compress=1&resize=400x300&vertical=center';
        } else {
          photoUrl = await StorageMethods()
              .uploadImageToStorage("profileImage", file, false);
        }
        // print("the photo url is:");
        // print(photoUrl);
        model.User user = model.User(
          email: mail,
          uid: uid,
          userName: userName,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
          tokens: 100,
        );
        await _firestore.collection("users").doc(uid).set(user.toJson());
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

  Future<String> Login_otp({
    required String phone,
  }) async {
    String res = "Some Error Occured";
    var completer = Completer<String>(); // Declare a Completer

    try {
      if (phone.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            Cred = await _auth.signInWithCredential(credential);
            res = "success";
            completer.complete(
                res); // Complete the completer when verification is complete
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == "invalid-phone-number") {
              res = "The provided phone number is not valid";
            } else {
              res = e.toString();
            }
            completer.complete(
                res); // Complete the completer when verification fails
          },
          codeSent: (String verificationId, int? resendToken) {
            res = 'code sent';
            VerificationId = verificationId;
            completer.complete(
                res);
            // Don't complete the completer here because verification is not yet complete
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Handle auto-retrieval timeout if necessary
          },
        );
      }
    } catch (_err) {
      res = _err.toString();
      completer.complete(res); // Complete the completer when there's an error
    }

    return completer.future; // Return the completer's future
  }

  Future<String> Login_otp_submit(
    String otp,
  ) async {
    String res = "Some Error Occured";
    if (VerificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: VerificationId,
        smsCode: otp,
      );
      final value = await _signInWithCredential(credential);
      // print("the value of value in _submitOtp funciton is: $value");
      if (value == "success") {
        return "success";
      } else {
        return value;
      }
    } else {
      return "mobile number not submitted";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
