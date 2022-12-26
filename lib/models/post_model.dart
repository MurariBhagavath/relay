import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class PostModel {
  PostModel({
    required this.uid,
    this.postId,
    required this.name,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.profile,
  });
  String uid;
  ObjectId? postId;
  String name;
  String profile;
  String imageUrl;
  String content;
  List likes;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        uid: json['uid'],
        postId: json['postId'],
        name: json['name'],
        profile: json['profile'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        likes: json['likes'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "postId": postId,
        "name": name,
        "profile": profile,
        "imageUrl": imageUrl,
        "content": content,
        "likes": likes,
      };
}
