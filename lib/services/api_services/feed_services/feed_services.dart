
import 'dart:convert';

import 'package:beat_jerky/model/api_models/feed_models/current_user_feed_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/providers/feeds_provider/current_user_feeds_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class FeedServices{


  getCurrentUSerAllFeeds(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getCurrentUserAllFeeds}${Provider.of<CurrentUserProvider>(context,listen: false).user!.userId}";

    print(uri);
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedsMap=data['data'];
      print(response.body);
      print(feedsMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<CurrentUserFeedsModel> feedList=[];
      for(int i=0; i<feedsMap.length;i++){

        feedList.add(CurrentUserFeedsModel.fromJson(feedsMap[i]));
      }
      print(feedList.length);
      Provider.of<CurrentUserFeedsProvider>(context,listen: false).updateFeeds(feedList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  getAllFeeds(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllFeeds}";

    http.Response response=await ApiServices().getService(uri:uri,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedsMap=data['data'];
      print(response.body);
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

  Future<bool> deleteFeed( int feedId,BuildContext context)async{
    var user= Provider.of<CurrentUserProvider>(context,listen: false).user;
    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.deleteFeed}?userId=${user!.userId}&feedId=$feedId";
    print(uri);
    Map<String,dynamic> body={

    };
    http.Response response=await ApiServices().deleteService(uri:uri,body:body,header: header);

    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      // var value=Provider.of<FeedsProvider>(context,listen: false).feedsList;
      // if(data["status"]=="success"){
      //   value[index].feedLikes.removeAt(likeIndex);
      // }


      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  uploadFeed(String imagePath,String description,BuildContext context)async{
    var user=Provider.of<CurrentUserProvider>(context,listen: false).user;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://beatjerky.com/api/feed'));
    request.fields.addAll({
      'userId': '${user!.userId}',
      'description': description
    });
    request.files.add(
        await http.MultipartFile.fromPath(
            'feed', imagePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      return true;
      // print(await response.stream.bytesToString());
    }
    else {
      return false;
      // print(response.reasonPhrase);
    }

  }


}