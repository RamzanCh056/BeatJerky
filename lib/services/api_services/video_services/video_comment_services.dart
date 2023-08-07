





import 'dart:convert';

import 'package:beat_jerky/model/api_models/feed_models/feed_comments_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/single_feed_comments_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feed_comments_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../model/api_models/video_models/single_video_comments_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../providers/video_provider/video_comments_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class VideoCommentServices{




  commentVideo(int userId, int videoId,String comment,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.videoComment}";
    Map<String,dynamic> body={
      'videoId':videoId,
      'userId':userId,
      'comment':comment
    };
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

  deleteVideoComment(int userId, int feedId,int commentId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    print(userId);
    print(feedId);
    print(commentId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.videoComment}";
    Map<String,dynamic> body={
      'videoId':feedId,
      'userId':userId,
      'commentId':commentId
    };
    print(uri);
    http.Response response=await ApiServices().deleteService(uri:uri,body:body,header: header);

    if(response.statusCode==200){

      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  getAllVideoComments(int videoId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllVideoComments}$videoId";
    // Map<String,dynamic> body={
    //   'feedId':feedId,
    //   // 'userId':userId
    // };
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    if(response.statusCode==200){
      print(response.body);
      var data= jsonDecode(response.body);
      List videoCommentsMap=data['data'];

      print(videoCommentsMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<SingleVideoCommentModel> commentList=[];
      for(int i=0; i< 10;i++) {
        print("===========><>${videoCommentsMap.length}<><============");
        print(videoCommentsMap.length);
      }

      for(int i=0; i<videoCommentsMap.length;i++){
        commentList.add(SingleVideoCommentModel.fromJson(videoCommentsMap[i]));
      }
      print(commentList.length);
      Provider.of<VideoCommentsProvider>(context,listen: false).update(commentList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


}