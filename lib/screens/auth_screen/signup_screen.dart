import 'package:beat_jerky/services/api_services/auth_services.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/backward_button.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:beat_jerky/widget/reusable_textformfield.dart';
import 'package:beat_jerky/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../services/shared_preferences_Services/auth_preferences.dart';
import '../bottom_nav_bar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _formKey=GlobalKey<FormState>();

  bool pass = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      BackwardButton(),
                      SizedBox(
                        width: 20,
                      ),
                      ReusableText(
                        title: "Sign Up",
                        size: 24,
                        weight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ReusableText(
                    title: "First Name",
                    size: 16,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ReusableTextForm(
                    controller: firstNameController,
                    capitalize: TextCapitalization.words,
                    hintText: "First Name",
                    validator: (value){
                      if(value ==null || value.isEmpty){
                        return 'This field is required';
                      }else{
                        return null;
                      }
                    },
                    // prefixIcon: Icon(
                    //   Icons.email_outlined,
                    //   color: whiteColor,
                    // ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ReusableText(
                    title: "Last Name",

                    size: 16,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ReusableTextForm(
                    controller: lastNameController,
                    capitalize: TextCapitalization.words,
                    hintText: "Last Name",
                    validator: (value){
                      if(value ==null || value.isEmpty){
                        return 'This field is required';
                      }else{
                        return null;
                      }
                    },
                    // prefixIcon: Icon(
                    //   Icons.email_outlined,
                    //   color: whiteColor,
                    // ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ReusableText(
                    title: "Email",
                    size: 16,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ReusableTextForm(
                    controller: emailController,
                    hintText: "Email",
                    validator: (value){
                      if(value ==null || value.isEmpty){
                        return 'This field is required';
                      }else if(!value.contains('@')&& !value.contains('.com')){
                        return 'Invalid email';
                      }else{
                        return null;
                      }
                    },
                    // prefixIcon: Icon(
                    //   Icons.email_outlined,
                    //   color: whiteColor,
                    // ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ReusableText(
                    title: "Password",
                    size: 16,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ReusableTextForm(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: pass,
                    suffixIcon: InkWell(
                      onTap: (){
                        setState(() {
                          pass = !pass;
                        });
                      },
                      child: Icon(
                        pass ? Icons.visibility : Icons.visibility_off,
                        color: whiteColor,
                      ),
                    ),
                    validator: (value){
                      if(value ==null || value.isEmpty){
                        return 'This field is required';
                      }else{
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  RoundButton(title: "Sign Up", onTap: () async{
                    if(_formKey.currentState!.validate()){
                      EasyLoading.show(status: "Signing up...");
                      bool value=await AuthServices().signUp(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          passwordController.text);

                      if(value) {
                        bool loggedIn=await AuthServices().login(emailController.text, passwordController.text, context);
                        EasyLoading.dismiss();
                        if(loggedIn) {
                          await AuthPreferences().setAuthPreferences(emailController.text, passwordController.text);
                          Get.to(()=>const BottomNavBar());
                        }else{
                          Get.showSnackbar(const GetSnackBar(message: "Error occurred while account creating",duration: Duration(seconds: 2),));
                        }

                      }else{
                        EasyLoading.dismiss();
                        Get.showSnackbar(const GetSnackBar(message: "Error occurred while account creating",duration: Duration(seconds: 2),));
                      }
                    }
                  },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ReusableText(
                        title: "Already have an account?",
                        size: 16,
                        color: whiteColor,
                      ),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child:
                      const ReusableText(
                        title: "Log in",
                        size: 16,
                        color: whiteColor,
                        weight: FontWeight.bold,
                      ),),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
