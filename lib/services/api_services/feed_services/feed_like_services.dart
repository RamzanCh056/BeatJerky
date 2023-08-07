





import 'dart:convert';

import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class FeedLikeServices{




  likeFeed(int userId, int feedId,int index,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.likeFeed}";
    Map<String,dynamic> body={
      'feedId':feedId,
      'userId':userId
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

  dislikeFeedLike(int userId, int feedId,int index,int likeId,int likeIndex,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.likeFeed}";
    Map<String,dynamic> body={
      'feedId':feedId,
      'userId':userId
    };
    http.Response response=await ApiServices().deleteService(uri:uri,body:body,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      var value=Provider.of<FeedsProvider>(context,listen: false).feedsList;
      if(data["status"]=="success"){
        value[index].feedLikes.removeAt(likeIndex);
      }


      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  getAllFeedLikes(int feedId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.likeFeed}";
    Map<String,dynamic> body={
      'feedId':feedId,
      // 'userId':userId
    };
    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedsMap=data['data'];


      print(feedsMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<FeedModel> feedList=[];
      for(int i=0; i<feedsMap.length;i++){

        feedList.add(FeedModel.fromJson(feedsMap[i]));
      }
      print(feedList.length);
      Provider.of<FeedsProvider>(context,listen: false).updateFeeds(feedList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


}