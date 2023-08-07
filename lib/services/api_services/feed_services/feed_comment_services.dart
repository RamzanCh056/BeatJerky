





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
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class FeedCommentServices{




  commentFeed(int userId, int feedId,String comment,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.commentFeed}";
    Map<String,dynamic> body={
      'feedId':feedId,
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

  deleteFeedComment(int userId, int feedId,int commentId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    print(userId);
    print(feedId);
    print(commentId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.commentFeed}";
    Map<String,dynamic> body={
      'feedId':feedId,
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


  getAllComments(int feedId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllFeedComments}$feedId";
    // Map<String,dynamic> body={
    //   'feedId':feedId,
    //   // 'userId':userId
    // };
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedCommentsMap=data['data'];

      print(feedCommentsMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<SingleFeedCommentModel> commentList=[];
      for(int i=0; i<feedCommentsMap.length;i++){

        commentList.add(SingleFeedCommentModel.fromJson(feedCommentsMap[i]));
      }
      print(commentList.length);
      Provider.of<CommentsProvider>(context,listen: false).update(commentList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


}