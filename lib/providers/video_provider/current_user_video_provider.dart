


import 'package:flutter/cupertino.dart';

import '../../model/api_models/video_models/current_user_video_model.dart';

class CurrentUserVideoProvider extends ChangeNotifier{
  List<CurrentUserVideoModel> videos=[];

  updateVideos(List<CurrentUserVideoModel> videoList){
    videos.clear();
    videos=videoList;
    notifyListeners();
  }
}