import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String userName;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final int token;

  const User({
    required this.email,
    required this.uid,
    required this.userName,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'userName': userName,
        'bio': bio,
        "photoUrl": photoUrl,
        'followers': followers,
        'following': following,
        'tokens': token,
      };

  static User fromSnap(DocumentSnapshot snap) {
    
    print(snap.data());
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'] ?? '',
      uid: snapshot['uid'] ?? '',
      userName: snapshot['userName'] ?? '',
      bio: snapshot['bio'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      followers: snapshot['followers'] ?? [],
      following: snapshot['following'] ?? [],
      token: snapshot['tokens'] ?? 0,
    );
  }
}
