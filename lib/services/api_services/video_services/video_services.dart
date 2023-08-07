
import 'dart:convert';

import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/model/api_models/video_models/current_user_video_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:beat_jerky/providers/video_provider/current_user_video_provider.dart';
import 'package:beat_jerky/providers/video_provider/videos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../model/api_models/video_models/video_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class VideoServices{
  getCurrentUserVideos(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getUserVideos}${Provider.of<CurrentUserProvider>(context,listen: false).user!.userId}";

    print(uri);
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    print("I have got response");
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List videosMap=data['data'];
      print(response.body);
      print(videosMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<CurrentUserVideoModel> videosList=[];
      for(int i=0; i<videosMap.length;i++){

        videosList.add(CurrentUserVideoModel.fromJson(videosMap[i]));
      }
      print(videosList.length);
      Provider.of<CurrentUserVideoProvider>(context,listen: false).updateVideos(videosList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  getAllVideos(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllUsersVideos}";

    print(uri);
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    print("I have got response");
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List videosMap=data['data'];
      print(response.body);
      print(videosMap.length);
      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<VideoModel> videosList=[];
      for(int i=0; i<videosMap.length;i++){

        videosList.add(VideoModel.fromJson(videosMap[i]));
      }
      print(videosList.length);
      Provider.of<VideosProvider>(context,listen: false).updateVideos(videosList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  Future<bool> deleteVideo( int videoId,BuildContext context)async{
    var user= Provider.of<CurrentUserProvider>(context,listen: false).user;
    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.video}?userId=${user!.userId}&videoId=$videoId";
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


  uploadVideo(String videoPath,String description,BuildContext context)async{
    var user=Provider.of<CurrentUserProvider>(context,listen: false).user;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://beatjerky.com/api/video'));
    request.fields.addAll({
      'userId': '${user!.userId}',
      'description': description
    });
    request.files.add(
        await http.MultipartFile.fromPath(
            'file', videoPath));

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