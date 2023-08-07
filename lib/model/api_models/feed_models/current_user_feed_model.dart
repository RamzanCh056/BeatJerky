
import 'package:beat_jerky/model/api_models/video_models/video_user_model.dart';


class CurrentUserFeedsModelFields{
  static const String videoId='id';
  static const String userId='userId';
  static const String description='description';
  static const String imageUrl='imageUrl';
  static const String isDeleted='isDeleted';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
  static const String videoLikes='videoLikes';
  static const String videoComments='videoComments';
}


class CurrentUserFeedsModel {
  int videoId;
  int userId;
  String description;
  String imageUrl;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  List videoLikes=[];
  List videoComments=[];

  CurrentUserFeedsModel({
   required this.userId,
   required this.videoId,
   required this.description,
   required this.isDeleted,
   required this.imageUrl,
   required this.createdAt,
   required this.videoComments,
   required this.videoLikes,
   required this.updatedAt
});

  factory CurrentUserFeedsModel.fromJson(Map<String,dynamic> json)=>CurrentUserFeedsModel(
      userId: json[CurrentUserFeedsModelFields.userId],
      videoId: json[CurrentUserFeedsModelFields.videoId],
      description: json[CurrentUserFeedsModelFields.description],
      isDeleted: json[CurrentUserFeedsModelFields.isDeleted],
      imageUrl: json[CurrentUserFeedsModelFields.imageUrl],
      createdAt: json[CurrentUserFeedsModelFields.createdAt],
      videoComments: json[CurrentUserFeedsModelFields.videoComments]??[],
      videoLikes: json[CurrentUserFeedsModelFields.videoLikes]??[],
      updatedAt: json[CurrentUserFeedsModelFields.updatedAt]
  );
}