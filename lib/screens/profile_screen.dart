import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:beat_jerky/model/api_models/feed_models/current_user_feed_model.dart';
import 'package:beat_jerky/model/api_models/video_models/current_user_video_model.dart';
import 'package:beat_jerky/model/api_models/video_models/video_model.dart';
import 'package:beat_jerky/providers/feeds_provider/current_user_feeds_provider.dart';
import 'package:beat_jerky/providers/follower_provider/followers_and_following_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/providers/video_provider/current_user_video_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/screens/settings_screen.dart';
import 'package:beat_jerky/screens/video_screen.dart';
import 'package:beat_jerky/services/api_services/feed_services/feed_services.dart';
import 'package:beat_jerky/services/api_services/follow_services/follow_services.dart';
import 'package:beat_jerky/services/api_services/video_services/video_services.dart';
import 'package:beat_jerky/shimmer_effect/profile_screen_skeleton.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

import '../controller/controller.dart';
import '../providers/video_provider/videos_provider.dart';
import '../utils/color.dart';
import '../utils/thumbnail_generator.dart';
import '../widget/round_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  

  Directory? _appDocDir;
  getDirectory()async{
    _appDocDir = await getApplicationDocumentsDirectory();
    setState(() {

    });
  }

  File? videoFile;
  File? galleryFile;
  final picker = ImagePicker();
  bool isVideo = true;
  bool isPic = false;


  List<CurrentUserVideoModel> videos= [];
  bool isThumbnailFetched=false;
  List<String?> thumbnails=[];

  getCurrentUserAllVideos()async{
    await VideoServices().getCurrentUserVideos(context);
    videos=Provider.of<CurrentUserVideoProvider>(context,listen: false).videos;
    print(videos.length);
    setState(() {

    });
  }

  List<CurrentUserFeedsModel> pictures=[];

  getCurrentUserAllFeeds()async{
    await
    FeedServices().getCurrentUSerAllFeeds(context);
    pictures=Provider.of<CurrentUserFeedsProvider>(context,listen: false).feeds;
    print(pictures.length);
    setState(() {

    });
  }

  getUserData()async{
    await FollowServices().getAllFollowersAndFollowing(context);
   await Provider.of<CurrentUserProvider>(context,listen: false).getCurrentUser(context);
   setState(() {

   });
  }

  bool isLoading=true;
  initializedScreen()async{

    await getDirectory();
    await getUserData();
    await getCurrentUserAllVideos();
    await getCurrentUserAllFeeds();
    setState(() {
      isLoading=false;
    });
  }


  getThumbnail(String url)async{
    try{
      String? filePath = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      return filePath;
    }catch(e){
      EasyLoading.showError(e.toString());
    }

  }


  GenThumbnailImage? _futreImage;
  String? _tempDir;

  getAllThumbnails()async{

  }





  @override
  void initState() {
    // PCC().d;
   
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    initializedScreen();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var provider=Provider.of<CurrentUserProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: transparentColor,
          elevation: 0,
          title: const ReusableText(title: "Profile"),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsScreen();
                  }),);
                },
                child: Icon(Icons.settings,color: whiteColor,)),
            SizedBox(width: 20,)
          ],
        ),
        body: !isLoading?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ReusableText(
                        title: Provider.of<FollowAndFollowingProvider>(context,listen: false).followers.toString(),
                        size: 18,
                        weight: FontWeight.w500,
                        color: greyColor,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const ReusableText(
                        title: "Followers",
                        size: 18,
                        weight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ],
                  ),
                  Stack(
                    children: [

                      Container(
                        height: 90,
                        width: 90,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: blackColor,
                            shape: BoxShape.circle,
                            border: GradientBoxBorder(
                              width: 2,
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomRight,
                                colors: [
                                  indigoColor,
                                  pinkColor,
                                ],
                              ),
                            )),
                        child:
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            provider.user!.imageUrl??
                            "http://beatjerky.com/api/profile/file_1688928075186_profile.png"
                          ),
                        // FadeInImage(
                        //   fit: BoxFit.contain,
                        //     placeholder: const AssetImage("assets/images/dp.jpg"),
                        //     image: NetworkImage(provider.user!.imageUrl!=null?provider.user!.imageUrl.toString():
                        //     "http://beatjerky.com/api/profile/file_1688928075186_profile.png")),
                        )
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: ()async{
                              _showPicker(context: context);
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              color: whiteColor,
                              size: 30,
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      ReusableText(
                        title: Provider.of<FollowAndFollowingProvider>(context,listen: false).following.toString(),
                        size: 18,

                        weight: FontWeight.w500,
                        color: greyColor,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const ReusableText(
                        title: "Following",
                        size: 18,
                        weight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ReusableText(
                title: "${provider.user!.firstName} ${provider.user!.lastName}",
                color: whiteColor,
                size: 18,
                weight: FontWeight.w700,
              ),
              const SizedBox(
                height: 5,
              ),
              const ReusableText(
                title: "Sprinkling kindness everywhere I go",
                color: greyColor,
                weight: FontWeight.w500,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: RoundButton(
                    title: 'Follow',
                    onTap: () {},
                  )),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                              indigoColor,
                              pinkColor,
                            ],
                          ),
                        ),
                      ),
                      child: const ReusableText(
                        title: "Edit",
                        size: 18,
                        weight: FontWeight.w400,
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isVideo = true;
                        isPic = false;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.video_library,
                              color: isVideo ? whiteColor : greyColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ReusableText(
                              title: "Videos",
                              size: 15,
                              color: isVideo ? whiteColor : greyColor,
                              weight: FontWeight.w700,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 3,
                          width: 100,
                          color: isVideo ? pinkColor : transparentColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isVideo = false;
                        isPic = true;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: isPic ? whiteColor : greyColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ReusableText(
                              title: "Photos",
                              size: 15,
                              color: isPic ? whiteColor : greyColor,
                              weight: FontWeight.w700,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 3,
                          width: 100,
                          color: isPic ? pinkColor : transparentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              isVideo
                  ? Expanded(
                      child:
                          GridView.builder(
                              itemCount: videos.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                              itemBuilder: (context,index){
                                return  InkWell(
                                  onTap: (){
                                    Get.to(()=>VideoScreenPage(video: videos[index]));
                                  },
                                  child: Container(
                                    height: 100,
                                    width:  100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white10,
                                      image: const DecorationImage(image: AssetImage(
                                        'assets/images/logo.png'
                                      ))
                                    ),
                                  ),
                                );
                              })



                      // Builder(
                      //   builder: (context) {
                      //     return GridView.builder(
                      //       itemCount: videos.length,
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 2,
                      //               crossAxisSpacing: 10,
                      //               mainAxisSpacing: 10),
                      //       itemBuilder: (BuildContext context, int index) {
                      //
                      //         getThumbnail(videos[index].videoUrl.replaceAll('public', ApiConstants.baseUrl));
                      //         print(getThumbnail(videos[index].videoUrl.replaceAll('public', ApiConstants.baseUrl)));
                      //         print("I am printing video");
                      //         return Container(
                      //           height: 50,
                      //           width: 50,
                      //
                      //           alignment: Alignment.center,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: Colors.white
                      //           ),
                      //           child: Image.file(File(VideoThumbnail.thumbnailFile(video: videos[index].videoUrl.replaceAll('public', ApiConstants.baseUrl)).toString())),
                      //
                      //         );
                      //
                      //       },
                      //     );
                      //   }
                      // ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        itemCount: pictures.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(pictures[index].imageUrl.replaceAll('public', ApiConstants.baseUrl)),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ):
        const ProfileScreenSkeleton(),
      ),
    );
  }

  void _showPicker({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage(ImageSource.gallery);

                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                },
              ),

              Center(
                child: InkWell(
                    onTap: ()async{
                  if(galleryFile!=null){
                    EasyLoading.show(status: "Uploading...");
                    await Provider.of<CurrentUserProvider>(context,listen: false).uploadProfilePicture(galleryFile!.path, context);
                  }
                },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width*.3,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)
                          ),
                          child: const Text("Upload",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    )),
              )

            ],
          ),
        );
      },
    );
  }

  Future getVideo(ImageSource img,) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future getImage(ImageSource img,) async {
    final pickedFile = await picker.pickImage(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        );
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
  
}
