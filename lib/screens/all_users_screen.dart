import 'dart:io';

import 'package:beat_jerky/model/api_models/feed_models/feed_comments_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/single_feed_comments_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feed_comments_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:beat_jerky/providers/users_provider/all_users_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/services/api_services/feed_services/feed_comment_services.dart';
import 'package:beat_jerky/services/api_services/feed_services/feed_services.dart';
import 'package:beat_jerky/services/api_services/follow_services/follow_services.dart';
import 'package:beat_jerky/services/api_services/user_services.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:beat_jerky/widget/reusable_textformfield.dart';
import 'package:beat_jerky/shimmer_effect/shimmer_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../model/api_models/user_model/all_users_model.dart';
import '../services/api_services/feed_services/feed_like_services.dart';
import '../shimmer_effect/user_profile_skeleton.dart';
class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {

  //
  // updateAllFeeds()async{
  //   await FeedServices().getAllFeeds(context);
  //   setState(() {
  //
  //   });
  // }

  bool isLoading=true;
  getAllUsers()async{

   await UserServices().getAllUsers(context);
   allUsers=Provider.of<AllUsersProvider>(context,listen: false).usersList;
   print(allUsers.length);
   setState(() {
     isLoading=false;
   });
  }

  List<AllUserModel> allUsers=[];
  @override
  void initState() {
    getAllUsers();
    // updateAllFeeds();
    // TODO: implement initState
    super.initState();
  }



  List<FeedModel> feedList=[];


  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<AllUsersProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: transparentColor,
          automaticallyImplyLeading: false,
          title: const ReusableText(
            title: "Beat Jerky",
          ),
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: whiteColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: whiteColor,
              ),
            ),
          ],
        ),
        body: isLoading?ListView.builder(
          itemCount: 8,
          // padding: const EdgeInsets.only(bottom: 10),
          itemBuilder: (BuildContext context, int index) {
            return const UserProfileSkeleton();
          },
        ):ListView.builder(
          itemCount: allUsers.length,
          // padding: const EdgeInsets.only(bottom: 10),
          itemBuilder: (BuildContext context, int index) {

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(allUsers[index].profileImg!=null?allUsers[index].profileImg!.replaceAll('public', ApiConstants.baseUrl):'https://firebasestorage.googleapis.com/v0/b/nail-technician-app.appspot.com/o/profile%20(2).png?alt=media&token=2bcdde88-6c54-443b-9f43-0354fa168698'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          title: "${allUsers[index].firstName} ${allUsers[index].lastName}",
                          size: 16,
                          weight: FontWeight.w700,
                          color: whiteColor,
                        ),
                        ReusableText(
                          title: allUsers[index].isOnline?'Online':'Offline',
                          size: 14,
                          // weight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    trailing: Container(
                      height: 30,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white70
                      ),
                      child: TextButton(
                        onPressed: ()async{
                          await FollowServices().followUser(allUsers[index].userId, context);
                        },
                        child: const ReusableText(title: "Follow",color: Colors.black,),
                      ),
                    )
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // NetworkImage(imageUrl),
                  // Image.network(imageUrl),
                  // FadeInImage(
                  //     placeholder: const AssetImage('assets/images/beet.jpg'),
                  //     image: NetworkImage(imageUrl)),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


}

