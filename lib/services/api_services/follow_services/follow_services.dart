



import 'dart:convert';

import 'package:beat_jerky/model/api_models/user_model/all_users_model.dart';
import 'package:beat_jerky/providers/follower_provider/followers_and_following_provider.dart';
import 'package:beat_jerky/providers/users_provider/all_users_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';

import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class FollowServices{


  followUser(int followeeId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };
    print(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.follow}";
    Map<String ,dynamic> body={
      "userId":Provider.of<CurrentUserProvider>(context,listen: false).user!.userId,
      "followerId":followeeId
    };
    print(body);


    print(uri);
    print(header);
    http.Response response=await ApiServices().postService(uri:uri,body: body,header: header);
    print(response.body);
    if(response.statusCode==200){
      EasyLoading.showSuccess("Followed Successfully");
      return true;
    }else if(response.statusCode==400){
      EasyLoading.showError("Already Followed");
      return false;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  getAllFollowersAndFollowing(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };
    print(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.getFollowersAndFollowing}${Provider.of<CurrentUserProvider>(context,listen: false).user!.userId}";
    Map<String ,dynamic> body={

    };

    print(uri);
    print(header);
    http.Response response=await ApiServices().getService(uri:uri,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);


      Provider.of<FollowAndFollowingProvider>(context,listen: false).updateFollowersAndFollowing(data['data']['follower'],data['data']['following']);

      print(response.body);
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


  uploadProfileImage(String imagePath,BuildContext context)async{
    var headers = {
      'Cookie': 'accessToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE0LCJmaXJzdE5hbWUiOiJTYWxpaCIsImxhc3ROYW1lIjoiSGF5YXQiLCJlbWFpbCI6InNhbGloQGdtYWlsLmNvbSIsImFkbWluIjpmYWxzZSwiaWF0IjoxNjg4OTY3NTE2LCJleHAiOjE2ODkwNTM5MTZ9.Jd9ITz9zj50w1B1GZyVATfE5yUGtpMA-_UZQL8loGeM'
    };

    String url= ApiConstants.baseUrl+ApiConstants.uploadProfileImage;

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.fields.addAll({
      'userId': Provider.of<CurrentUserProvider>(context,listen: false).user!.userId.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send().whenComplete((){
      EasyLoading.showToast("Uploaded successfully",duration: const Duration(seconds: 2),toastPosition: EasyLoadingToastPosition.bottom);
      EasyLoading.dismiss();
    });

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }


}