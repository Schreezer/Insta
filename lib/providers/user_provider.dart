import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_methos.dart';
import 'package:instagram/utils/global_variables.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User? get getUser => _user;
  Future <void> refreshUser(bool internal) async {
    User? user = await _authMethods.getUserDetails();
    if(internal){
    if (_user==null) {
      _user = user;
      // print("new user");

      notifyListeners();
    }
    }
    else{
      _user = user;
      // print("new user");

      notifyListeners();
    }
    // if(_user==user){
    //   return;
    // }
    // else{
    //   _user = user;
    //   notifyListeners();
    // }
    // print(user.uid);
  }

}