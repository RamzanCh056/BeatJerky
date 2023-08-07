import 'package:beat_jerky/screens/auth_screen/signup_screen.dart';
import 'package:beat_jerky/screens/bottom_nav_bar.dart';
import 'package:beat_jerky/services/shared_preferences_Services/auth_preferences.dart';

import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/backward_button.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:beat_jerky/widget/reusable_textformfield.dart';
import 'package:beat_jerky/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/api_services/auth_services.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _form = GlobalKey<FormState>();

  bool pass = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return await showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: const Text("Are you sure to exit"),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("No")),
                  TextButton(onPressed: ()=>Navigator.pop(context,true), child: const Text("Exit")),

                ],
              );
            });
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:
            const ReusableText(
              title: "Log in",
              size: 24,
              weight: FontWeight.bold,
              color: whiteColor,
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: const [
                    //     BackwardButton(),
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //     ReusableText(
                    //       title: "Log in",
                    //       size: 24,
                    //       weight: FontWeight.bold,
                    //       color: whiteColor,
                    //     ),
                    //   ],
                    // ),
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
                      title: "Email",
                      size: 16,
                      color: whiteColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ReusableTextForm(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                       controller: passwordController,

                       validator: (value){
                         if(value ==null || value.isEmpty){
                           return 'Password is required';
                         }else{
                           return null;
                         }
                       },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: ()=>Get.to(()=>const ForgotPasswordScreen()),
                          child: const Text("Forgot Password?")),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(title: "Log in", onTap: () async{
                      if(_form.currentState!.validate()){
                        EasyLoading.show(status: "Signing in...");
                        bool value=await AuthServices().login(emailController.text, passwordController.text,context);
                        EasyLoading.dismiss();
                        if(value) {
                          await AuthPreferences().setAuthPreferences(emailController.text, passwordController.text);
                         Get.to(()=>const BottomNavBar());
                        }else{
                          Get.showSnackbar(const GetSnackBar(message: "Invalid email or password",duration: Duration(seconds: 2),));
                        }
                      }

                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ReusableText(
                          title: "Don't have an account?",
                          size: 16,
                          color: whiteColor,
                        ),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return const SignupScreen();
                          }),);
                        }, child:
                        const ReusableText(
                          title: "Sign Up",
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
      ),
    );
  }
}
