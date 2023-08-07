
import 'dart:convert';

import 'package:beat_jerky/model/api_models/user_model/all_users_model.dart';
import 'package:beat_jerky/providers/users_provider/all_users_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../model/api_models/user_model/user_model.dart';
import '../../providers/users_provider/current_user_provider.dart';
import '../../repo/api_consts.dart';
import '../../repo/api_services.dart';

class UserServices{


  getCurrentUser(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };
    print(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.getCurrentUser}${Provider.of<CurrentUserProvider>(context,listen: false).user!.userId}";
    Map<String ,dynamic> body={

    };

    print(uri);
    print(header);
    http.Response response=await ApiServices().getService(uri:uri,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      String? imageUrl=data['data'][0]['profileImg'];
      imageUrl=imageUrl?.replaceAll('public', ApiConstants.baseUrl);
      Provider.of<CurrentUserProvider>(context,listen: false).user!.imageUrl=imageUrl;
      print(response.body);
      print(response.body);
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  getAllUsers(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };
    print(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllUsers}";
    Map<String ,dynamic> body={

    };

    print(uri);
    print(header);
    http.Response response=await ApiServices().getService(uri:uri,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List usersMap=data['data'];

      List<AllUserModel> allUsersList=[];
      for(int i=0;i<usersMap.length;i++){
        AllUserModel user=AllUserModel.fromJson(usersMap[i]);
        allUsersList.add(user);
      }

      Provider.of<AllUsersProvider>(context,listen: false).updateUsers(allUsersList);

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


  logoutUser(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };
    print(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId);
    String uri="${ApiConstants.baseUrl}${ApiConstants.logout}";
    Map<String ,dynamic> body={
      'userId':Provider.of<CurrentUserProvider>(context,listen: false).user!.userId
    };

    print(body);
    print(uri);
    print(header);
    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);
    print(response.body);
    if(response.statusCode==200){

      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }



}