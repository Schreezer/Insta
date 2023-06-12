import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postId;
  final String photoUrl;
  final datePublished;
  final likes;
  final String profImage;

  const Post({
    required this.description,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.photoUrl,
    required this.datePublished,
    required this.likes,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'userName': userName,
        'postId': postId,
        "photoUrl": photoUrl,
        'datePublished': datePublished,
        'likes': likes,
        'profImage': profImage,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'] ?? '',
      uid: snapshot['uid'] ?? '',
      userName: snapshot['userName'] ?? '',
      postId: snapshot['postId'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      datePublished: snapshot['datePublished'] ?? [],
      likes: snapshot['likes'] ?? [],
      profImage: snapshot['profImage'] ?? [],
    );
  }
}
