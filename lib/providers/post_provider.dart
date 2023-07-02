import "package:flutter/material.dart";

import "../models/post.dart";

class PostProvider with ChangeNotifier {
  Post? _post;
  Post? get getPost => _post;
  Future <void> refreshPost(Post post) async {
    _post = post;
    notifyListeners();
  }
}