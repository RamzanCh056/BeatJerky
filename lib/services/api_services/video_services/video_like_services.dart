





import 'dart:convert';

import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/model/api_models/video_models/single_video_Likes_model.dart';
import 'package:beat_jerky/model/api_models/video_models/video_likes_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:beat_jerky/providers/video_provider/video_likes_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class VideoLikeServices{




  likeVideo(int userId, int videoId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.likeVideo}";
    print(uri);
    Map<String,dynamic> body={
      'videoId':videoId,
      'userId':userId
    };
    print(body);
    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);

      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  dislikeVideo(int userId, int videoId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.likeVideo}";
    Map<String,dynamic> body={
      'videoId':videoId,
      'userId':userId
    };
    http.Response response=await ApiServices().deleteService(uri:uri,body:body,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      if(data["status"]=="success"){

      }


      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  getAllVideoLikes(int videoId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllVideoLikes}$videoId";
    print(uri);
    // Map<String,dynamic> body={
    //   'feedId':videoId,
    //   // 'userId':userId
    // };
    http.Response response=await ApiServices().getService(uri:uri,header: header);


    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List likeMap=data['data'];

      print(likeMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<SingleVideoLikesModel> likesList=[];
      for(int i=0; i<likeMap.length;i++){

        likesList.add(SingleVideoLikesModel.fromJson(likeMap[i]));
      }
      print(likesList.length);
      Provider.of<VideoLikesProvider>(context,listen: false).updateVideoLikes(likesList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


}