import 'package:beat_jerky/screens/auth_screen/signup_screen.dart';
import 'package:beat_jerky/screens/bottom_nav_bar.dart';

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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _form = GlobalKey<FormState>();

  bool pass = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
          const ReusableText(
            title: "Forgot Password",
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
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
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
                  RoundButton(title: "Submit", onTap: () async{
                    if(_form.currentState!.validate()){
                      EasyLoading.show(status: "Loading...");
                      bool value=await AuthServices().forgotPassword(emailController.text,context);
                      EasyLoading.dismiss();
                      if(value) {
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        //   return const BottomNavBar();
                        // }),);
                      }else{
                        Get.showSnackbar(const GetSnackBar(message: "Invalid email",duration: Duration(seconds: 2),));
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
    );
  }
}
