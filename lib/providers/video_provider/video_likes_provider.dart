


import 'package:beat_jerky/model/api_models/video_models/single_video_Likes_model.dart';
import 'package:flutter/cupertino.dart';

import '../../model/api_models/video_models/video_likes_model.dart';

class VideoLikesProvider extends ChangeNotifier{

  List<SingleVideoLikesModel> videoLikes=[];

  updateVideoLikes(List<SingleVideoLikesModel> videoLikeList){
    videoLikes.clear();
    videoLikes=videoLikeList;
    notifyListeners();
  }


}