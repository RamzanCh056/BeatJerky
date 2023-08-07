
import 'dart:convert';

import 'package:beat_jerky/model/api_models/user_model/user_model.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../repo/api_consts.dart';
import '../../repo/api_services.dart';

class AuthServices{

  login(String email, String password,BuildContext context)async{

    var header= {
      'Content-Type':'application/json'
    };
    String uri=ApiConstants.baseUrl+ApiConstants.login;
    Map<String ,dynamic> body={
      'email':email,
      'password':password,
      'isAdmin': false
    };

    print(uri);
    print(body);
    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);

      Provider.of<CurrentUserProvider>(context,listen: false).
      updateUser(UserModel.fromJson(data['data']));

      print(response.body);
      print(response.body);
      return true;
    }else{
      return false;
    }


  }

  forgotPassword(String email,BuildContext context)async{

    var header= {
      'Content-Type':'application/json'
    };
    String uri=ApiConstants.baseUrl+ApiConstants.forgotPassword;
    Map<String ,dynamic> body={
      'email':email,
    };

    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      EasyLoading.showSuccess("We have sent password reset link to provided email, please check email",duration: const Duration(seconds: 3));
      // print(response.body);
      return true;
    }else{
      return false;
    }


  }

  signUp(String firstName,String lastName,String email, String password)async{

    var header= {
      'Content-Type':'application/json'
    };
    String uri=ApiConstants.baseUrl+ApiConstants.signup;
    Map<String ,dynamic> body={
      'firstName':firstName,
      'lastName' : lastName,
      'email':email,
      'password':password,
    };

    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);
    print(response.body);
    if(response.statusCode==200){
      print(response.body);
      print(response.body);
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }


}