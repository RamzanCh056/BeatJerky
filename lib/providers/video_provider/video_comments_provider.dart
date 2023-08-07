


import 'package:beat_jerky/model/api_models/feed_models/single_feed_comments_model.dart';
import 'package:beat_jerky/model/api_models/video_models/single_video_comments_model.dart';
import 'package:flutter/material.dart';

import '../../model/api_models/feed_models/feed_comments_model.dart';

class VideoCommentsProvider extends ChangeNotifier{
  List<SingleVideoCommentModel> videoComments=[];

  update(List<SingleVideoCommentModel> comments){
    videoComments.clear();
    videoComments=comments;
    notifyListeners();
  }

}