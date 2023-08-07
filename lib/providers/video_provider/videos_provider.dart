


import 'package:beat_jerky/model/api_models/video_models/video_model.dart';
import 'package:flutter/cupertino.dart';

import '../../model/api_models/feed_models/feed_model.dart';


class VideosProvider extends ChangeNotifier{
  List<VideoModel> videosList=[];

  updateVideos(List<VideoModel> videos){
    videosList=videos;
    notifyListeners();
  }

}