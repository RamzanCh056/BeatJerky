



class FeedCommentModelFields{
  static const String commentId='id';
  static const String userId='userId';
  static const String feedId='feedId';
  static const String comment='comment';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
}

class FeedCommentModel{
  int commentId;
  int userId;
  int feedId;
  String comment;
  String createdAt;
  String updatedAt;

  FeedCommentModel({
    required this.commentId,
    required this.userId,
    required this.feedId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt
  });

  factory FeedCommentModel.fromJson(Map<String,dynamic>json)=>FeedCommentModel(
      commentId: json[FeedCommentModelFields.commentId],
      userId: json[FeedCommentModelFields.userId],
      feedId: json[FeedCommentModelFields.feedId],
      comment: json[FeedCommentModelFields.comment],
      createdAt: json[FeedCommentModelFields.createdAt],
      updatedAt: json[FeedCommentModelFields.updatedAt]
  );

}