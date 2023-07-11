import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/comment.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postId;
  final List<dynamic> photoUrl;
  final datePublished;
  final likes;
  final String profImage;
  final int bounty;
  List<dynamic> comments ;

  Post({
    required this.bounty,
    required this.description,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.photoUrl,
    required this.datePublished,
    required this.likes,
    required this.profImage,
    this.comments = const [],
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'bounty': bounty,
        'userName': userName,
        'postId': postId,
        "photoUrl": photoUrl,
        'datePublished': datePublished,
        'likes': likes,
        'profImage': profImage,
        'comments': comments,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'] ?? '',
      uid: snapshot['uid'] ?? '',
      bounty: snapshot['bounty'] ?? 0,
      userName: snapshot['userName'] ?? '',
      postId: snapshot['postId'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? [],
      datePublished: snapshot['datePublished'] ?? '',
      likes: snapshot['likes'] ?? [],
      profImage: snapshot['profImage'] ?? '',
      comments: snapshot['comments'] ?? [],
    );
  }
}
