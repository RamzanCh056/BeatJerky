



class ApiConstants{

  static const String baseUrl='http://beatjerky.com/api';
  static const String signup='/auth/signup';
  static const String login='/auth/login';
  static const String forgotPassword='/auth/forgotPassword';

  /// Get Users
  static const String getCurrentUser='/users/current?userId=';
  static const String uploadProfileImage='/users/profileImg';
  static const String getAllUsers='/users';
  static const String logout='/auth/logout';


  /// Feeds
  static const String getAllFeeds='/feed/all';
  static const String deleteFeed='/feed';
  static const String getCurrentUserAllFeeds='/feed/?userId=';

  /// Feed Likes
  static const String likeFeed='/feedLike';
  static const String allFeedLikes='/feedLike/all?feedId=';

  /// Feed Comments
  static const String commentFeed='/feedComment';
  static const String getAllFeedComments='/feedComment/all?feedId=';

  /// Videos
  static const String postVideo='/video';
  static const String getUserVideos='/video/?userId=';
  static const String deleteVideo='/video?userId=';
  static const String getAllUsersVideos='/video/all';

  /// Video Likes
  static const String likeVideo='/videoLike';
  static const String getAllVideoLikes='/videoLike/all?videoId=';

  /// Video Comments
  static const String videoComment='/videoComment';
  static const String getAllVideoComments='/videoComment/all?videoId=';


  /// Video
  static const String video='/video';

  /// Follow
  static const String follow='/follower';
  static const String getFollowersAndFollowing='/follower?userId=';

  /// All categories with songs
  static const String allCategoriesWithSongs='/category/getAllCategoriesWithSongs';

  /// Music style songs category by id
  static const String getMusicStylesById='/musicStyleSongs/all?categoryId=';
  static const String getAllMusicStyles='/musicStyle/all';

  /// Chat
  static const String startChat='/message/start';
  static const String message='/message';
  static const String getConversationById='/message?conversationId=';
  static const String getChatList='/message/list?userId=';

}