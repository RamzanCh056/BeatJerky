



class FeedLikesModelFields{
  static const String likeId='id';
  static const String userId='userId';
  static const String feedId='feedId';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
}

class FeedLikesModel{
  int likeId;
  int userId;
  int feedId;
  String createdAt;
  String updatedAt;

  FeedLikesModel({
   required this.likeId,
   required this.userId,
   required this.feedId,
   required this.createdAt,
   required this.updatedAt
});

  factory FeedLikesModel.fromJson(Map<String,dynamic>json)=>FeedLikesModel(
      likeId: json[FeedLikesModelFields.likeId],
      userId: json[FeedLikesModelFields.userId],
      feedId: json[FeedLikesModelFields.feedId],
      createdAt: json[FeedLikesModelFields.createdAt],
      updatedAt: json[FeedLikesModelFields.updatedAt]
  );

}