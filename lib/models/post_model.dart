import 'package:flutter/cupertino.dart';

class Post {
  int postId;
  int userId;
  String content;
  double postScore;
  Color postColor;
  bool isTagged;

  Post({required this.postId, required this.userId, required this.content, required this.postScore, required this.postColor, required this.isTagged});
}