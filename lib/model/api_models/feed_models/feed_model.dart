

import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_user_model.dart';

import 'feed_comments_model.dart';

class FeedModelFields{
  static const String feedId='id';
  static const String userId='userId';
  static const String description='description';
  static const String imageUrl='imageUrl';
  static const String isDeleted='isDeleted';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
  static const String user='user';
  static const String feedLikes='feedLikes';
  static const String feedComments='feedComments';
}


class FeedModel {
  int feedId;
  int userId;
  String description;
  String imageUrl;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  FeedUserModel? user;
  List feedLikes=[];
  List feedComments=[];

  FeedModel({
   required this.userId,
   required this.feedId,
   required this.description,
   required this.isDeleted,
   required this.imageUrl,
   required this.user,
   required this.createdAt,
   required this.feedComments,
   required this.feedLikes,
   required this.updatedAt
});

  factory FeedModel.fromJson(Map<String,dynamic> json)=>FeedModel(
      userId: json[FeedModelFields.userId],
      feedId: json[FeedModelFields.feedId],
      description: json[FeedModelFields.description],
      isDeleted: json[FeedModelFields.isDeleted],
      imageUrl: json[FeedModelFields.imageUrl],
      user: FeedUserModel.fromJson(json[FeedModelFields.user]),
      createdAt: json[FeedModelFields.createdAt],
      feedComments: json[FeedModelFields.feedComments],
      feedLikes: json[FeedModelFields.feedLikes],
      updatedAt: json[FeedModelFields.updatedAt]
  );
}