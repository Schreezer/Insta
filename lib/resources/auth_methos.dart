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
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // send otp button:
  // this button sets the varaibles of the class, which were not declared previously, so that they can be used later in the code
  // it also calls the AuthenticateUser function, which sends the otp to the user, and that function can automatically check if the otp has arrived or not
  // if the otp has arrived, then Authenticate user function will pass the string 'success' and this function automatically calls the signupUser function, which signs up the user
  // if the otp has not arrived, then Authenticate user function will pass the error message, and this function will return that error message
  // then
  Future<String> sendOtp(
    String phoneNumber,
    String mail,
    String userName,
    String bio,
    Uint8List? file,
  ) async {
    Bio = bio;
    UserName = userName;
    Mail = mail;
    Imager = file;
    PhoneNumber = phoneNumber;
    String res = "Some Err Occured";
    try {
      if (phoneNumber.isNotEmpty &&
          mail.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty) {
        res = await AuthenticateUser(phone: phoneNumber);
        print("running sendotp in auth methods");
        print(res);
        if (res == "success") {
          res = await signupUser(
              phoneNumber: PhoneNumber,
              mail: Mail,
              bio: Bio,
              userName: UserName,
              file: file,
              cred: Cred);
        }
      }
    } catch (error) {
      res = error.toString();
    }
    print(res);
    return res;
  }

  Future<String> Register(
    String Otp,
  ) async {
    var val = await _submitOTP(Otp, VerificationId);
    print("the value of val in Register function is: $val");
    // ignore: unrelated_type_equality_checks
    print("the mail is $Mail");
    print("the bio is $Bio");
    print("the username is $UserName");
    print("the phone number is $PhoneNumber");
    print("the cred is $Cred");

    if (val == "success") {
      signupUser(
          mail: Mail,
          bio: Bio,
          userName: UserName,
          phoneNumber: PhoneNumber,
          file: Imager,
          cred: Cred);
      return "success";
    } else {
      return val;
    }
  }

  Future<String> AuthenticateUser({required String phone}) async {
    String res = "Starting phone authentication...";
    final completer = Completer<String>();

    try {
      if (phone.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            Cred = await _auth.signInWithCredential(credential);
            print(Cred.user!.uid);
            res = "success";
            print("Verification completed");
          },
          verificationFailed: (FirebaseAuthException e) {
            print("verification failed");
            if (e.code == "invalid-phone-number") {
              res = "The provided phone number is not valid";
              print("The provided phone number is not valid");
            } else {
              res = e.toString();
              print(e.toString());
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            // Save the verification ID to use later
            print("code sent");
            res = 'code sent';
            VerificationId = verificationId;
            completer.complete(res);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("code auto retrieval timeout");
            // res = 'manual verification required';
          },
        );
      }
    } catch (error) {
      res = error.toString();
      completer.complete(res);
    }
    print(res);
    return completer.future;
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
      print("the value of value in _submitOtp funciton is: $value");
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
    required UserCredential cred,
  }) async {
    String res = "Some Error Occured";
    print("signning up the user");
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
        print("the photo url is:");
        print(photoUrl);
        model.User user = model.User(
          email: mail,
          uid: Cred.user!.uid,
          userName: userName,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
          token: 100,
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
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
    try {
      if (phone.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            Cred = await _auth.signInWithCredential(credential);
            print(Cred.user!.uid);
            res = "success";
            print("Verification completed");
          },
          verificationFailed: (FirebaseAuthException e) {
            print("verification failed");
            if (e.code == "invalid-phone-number") {
              res = "The provided phone number is not valid";
              print("The provided phone number is not valid");
            } else {
              res = e.toString();
              print(e.toString());
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            // Save the verification ID to use later
            print("code sent");
            res = 'code sent';
            VerificationId = verificationId;
            
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("code auto retrieval timeout");
            // res = 'manual verification required';
          },
        );
      }

    } catch (_err) {
      res = _err.toString();
    }
    return res;
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
      print("the value of value in _submitOtp funciton is: $value");
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
