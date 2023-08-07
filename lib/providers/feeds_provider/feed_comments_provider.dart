


import 'package:beat_jerky/model/api_models/feed_models/single_feed_comments_model.dart';
import 'package:flutter/material.dart';

import '../../model/api_models/feed_models/feed_comments_model.dart';

class CommentsProvider extends ChangeNotifier{
  List<SingleFeedCommentModel> feedComments=[];

  update(List<SingleFeedCommentModel> comments){
    feedComments.clear();
    feedComments=comments;
    notifyListeners();
  }

}