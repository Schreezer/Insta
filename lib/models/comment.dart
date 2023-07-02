import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/like.dart';

class Comment {
  String uid; // of the person commenting
  String text; //
  String userName;//
  String profilePic;//
  String commentId; //
  List<Like> likes; 
  List<String> pics; //
  final datePublished;//
  // the urls of the pics the comments will have

  Comment({
    required this.uid,
    required this.text,
    required this.userName,
    required this.profilePic,
    required this.commentId,
    required this.datePublished,
    this.likes = const [],
    this.pics = const [],
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'text': text,
        'userName': userName,
        'profilePic': profilePic,
        'commentId': commentId,
        'datePublished': datePublished,
        'likes': likes,
        'pics': pics,
      };
  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      uid: snapshot['uid'] ?? '',
      text: snapshot['text'] ?? '',
      userName: snapshot['userName'] ?? '',
      profilePic: snapshot['profilePic'] ?? '',
      datePublished: snapshot['datePublished'] ?? [],
      commentId: snapshot['commentId'] ?? '',
    );
  }
}
