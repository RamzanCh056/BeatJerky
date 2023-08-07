import 'dart:async';

import 'package:beat_jerky/model/api_models/user_model/user_model.dart';
import 'package:beat_jerky/screens/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/api_services/auth_services.dart';
import '../services/shared_preferences_Services/auth_preferences.dart';
import 'bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), ()async {
      Map<String,dynamic> authData=await AuthPreferences().getAuthPreferences();
      if(authData[UserModelFields.email]!='' && authData[UserModelFields.userId] !=''){
        String email=authData[UserModelFields.email];
        String password = authData[UserModelFields.userId];
        bool isLoggedIn=await AuthServices().login(email, password, context);
        if(isLoggedIn){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const BottomNavBar()), (route) => false);

        }
      }else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
