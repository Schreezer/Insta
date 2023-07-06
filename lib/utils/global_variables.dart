import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:instagram/screens/add_post_screen.dart";
import "package:instagram/screens/favourites.dart";
import "package:instagram/screens/feed_screen.dart";
import "package:instagram/screens/guest_profile.dart";
import "package:instagram/screens/profile_screen.dart";
import "package:instagram/screens/search_screen.dart";

const webScreenSize = 600;
User? currentUser = FirebaseAuth.instance.currentUser   ;
var VerificationId = '';
var Bio = "";
var UserName = "";
var Mail = "";
var PhoneNumber = "";
var Imager;
var G_uid = "";
bool signedUp = false;
// ignore: non_constant_identifier_names, cast_from_null_always_fails
UserCredential Cred = null as UserCredential;

var homeScreenItems = [
  // Text("Home"),
  // Text("Search"),
  // Text("Add Post"),
  // Text("Favourite"),
  // Text("Profile"),

  const FeedScreen(),
  // const SearchScreen(),
  // const Placeholder(),
  const AddPostScreen(),
  // const favouriteScreen(),
  currentUser!=null ? ProfileScreen(uid: currentUser!.uid) : guestProfile(),

];