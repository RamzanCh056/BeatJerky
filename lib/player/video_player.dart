import 'package:beat_jerky/model/api_models/video_models/single_video_Likes_model.dart';
import 'package:beat_jerky/model/api_models/video_models/single_video_comments_model.dart';
import 'package:beat_jerky/model/api_models/video_models/video_comments_model.dart';
import 'package:beat_jerky/model/api_models/video_models/video_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feed_comments_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/providers/video_provider/video_comments_provider.dart';
import 'package:beat_jerky/providers/video_provider/video_likes_provider.dart';
import 'package:beat_jerky/providers/video_provider/videos_provider.dart';
import 'package:beat_jerky/services/api_services/video_services/video_comment_services.dart';
import 'package:beat_jerky/services/api_services/video_services/video_like_services.dart';
import 'package:beat_jerky/shimmer_effect/video_screen_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controller/controller.dart';
import '../model/api_models/user_model/user_model.dart';
import '../repo/api_consts.dart';
import '../services/api_services/video_services/video_services.dart';
import '../utils/color.dart';
import '../widget/reusable_text.dart';
import '../widget/reusable_textformfield.dart';


class Player extends StatefulWidget {


  final int i;
  Player({Key? key, required this.i}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  TextEditingController descriptionController=TextEditingController();
  TextEditingController commentController=TextEditingController();

  XFile? videoFile;
  final picker = ImagePicker();
  bool isVideo = true;
  bool isPic = false;


  bool isLoading=true;
  getAllVideos()async{

    await VideoServices().getAllVideos(context);

    setState(() {
      isLoading=false;
    });
  }

  updateAllVideos()async{
    await VideoServices().getAllVideos(context);
    setState(() {

    });
  }

  getVideoCommentsAndLikes()async{
    VideoModel video= Provider.of<VideosProvider>(context,listen: false).videosList[widget.i];
     UserModel? user =Provider.of<CurrentUserProvider>(context,listen: false).user;
    await VideoCommentServices().getAllVideoComments(video.videoId, context);
    await VideoLikeServices().getAllVideoLikes(video.videoId, context);
    comments=Provider.of<VideoCommentsProvider>(context,listen: false).videoComments;
    List<SingleVideoLikesModel> likes=Provider.of<VideoLikesProvider>(context,listen: false).videoLikes;
    likesList.clear();

    for(int i=0 ; i<likes.length;i++){
      if(likes[i].userId==Provider.of<CurrentUserProvider>(context,listen: false).user!.userId){
        likesList.add(i);
      }
    }

    setState(() {

    });
  }

  @override
  void initState() {
    getVideoCommentsAndLikes();
    // TODO: implement initState
    super.initState();
  }

  final VideoController c = Get.find();

  /// This list only contains one item if and only if I have or current user
  /// has liked this video else it will be empty
  List<int> likesList=[];
  List<SingleVideoCommentModel> comments=[];

  @override
  void dispose() {
    VideoController().disposeController(widget.i);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoModel video= Provider.of<VideosProvider>(context,listen: false).videosList[widget.i];
    // List<SingleVideoCommentModel> comments=Provider.of<VideoCommentsProvider>(context,listen: false).videoComments;
    List<SingleVideoLikesModel> likes=Provider.of<VideoLikesProvider>(context,listen: false).videoLikes;


    return
      GetBuilder<VideoController>(
      initState: (x) async {
        //Need to change conditions according preaload page count
        //Don't load too many pages it will cause performance issue.
        // Below is for 1 page preaload.
        if (c.api > 1) {
          await c.disposeController(c.api - 2);
        }
        if (c.api < c.videoPlayerControllers.length - 2) {
          await c.disposeController(c.api + 2);
        }
        if (!c.initilizedIndexes.contains(widget.i)) {
          getVideoCommentsAndLikes();
          await c.initializePlayer(widget.i,context);
        }
        if (c.api > 0) {
          if (c.videoPlayerControllers[c.api - 1] == null) {
            await c.initializeIndexedController(c.api - 1,context);
          }
        }
        if (c.api < c.videoPlayerControllers.length - 1) {
          if (c.videoPlayerControllers[c.api + 1] == null) {
            await c.initializeIndexedController(c.api + 1,context);
          }
        }
      },
      builder: (_) {
        if (c.videoPlayerControllers.isEmpty ||
            c.videoPlayerControllers[c.api] == null ||
            !c.videoPlayerControllers[c.api]!.value.isInitialized) {


          return const Center(child: CircularProgressIndicator(color: indigoColor,));
        }

        if (widget.i == c.api) {
          //If Index equals Auto Play Index
          //Set AutoPlay True Here
          if (widget.i < c.videoPlayerControllers.length) {
            if (c.videoPlayerControllers[c.api]!.value.isInitialized) {
              c.videoPlayerControllers[c.api]!.play();
            }
          }
          print('AutoPlaying ${c.api}');
        }
        return Stack(
          children: [
            c.videoPlayerControllers.isNotEmpty &&
                c.videoPlayerControllers[c.api]!.value.isInitialized
                ? GestureDetector(
              onDoubleTap: (){
                if (c.videoPlayerControllers[c.api]!.value.isPlaying) {
                  print("paused");
                  c.videoPlayerControllers[c.api]!.pause();
                } else {
                  c.videoPlayerControllers[c.api]!.play();
                  print("playing");
                }
              },
              onTap: () {

              },
              child:

              VideoPlayer(c.videoPlayerControllers[c.api]!),
            )
                : const VideoScreenSkeleton(),
            c.videoPlayerControllers.isNotEmpty &&
                c.videoPlayerControllers[c.api]!.value.isInitialized
                ?Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 5,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const ReusableText(title: "Following",size: 18,weight: FontWeight.w700,color: whiteColor,),
                  //     const SizedBox(width: 10,),
                  //     Container(
                  //       height: 15,
                  //       width: 2,
                  //       color: whiteColor,
                  //     ),
                  //     const SizedBox(width: 10,),
                  //     const ReusableText(title: "For You",size: 18,weight: FontWeight.w700,color: whiteColor,),
                  //
                  //   ],
                  // ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        //like
                        InkWell(
                          onTap:(){
                            if(likesList.isNotEmpty){
                              VideoLikeServices().dislikeVideo(
                              Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!,
                                  video.videoId,
                                  context);
                              VideoLikeServices().getAllVideoLikes(video.videoId, context);
                              getVideoCommentsAndLikes();
                              setState(() {

                              });
                            }else{
                              VideoLikeServices().likeVideo(
                                  Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!,
                                  video.videoId,
                                  context);
                              VideoLikeServices().getAllVideoLikes(video.videoId, context);
                              getVideoCommentsAndLikes();
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color: blackColor.withOpacity(0.3),
                            ),
                            child: likesList.isEmpty?const Icon(Icons.favorite,color: whiteColor,):
                            const Icon(Icons.favorite,color: Colors.red,),
                          ),
                        ),
                        SizedBox(height: 5,),
                        ReusableText(title: likes.length.toString(),color: whiteColor,weight: FontWeight.w700,),
                        SizedBox(height: 10,),
                        //comment
                        InkWell(
                          onTap: (){
                            _showComments(context: context, videoId: video.videoId);
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color: blackColor.withOpacity(0.3),
                            ),
                            child: const Icon(Icons.messenger,color: whiteColor,),
                          ),
                        ),
                        SizedBox(height: 5,),
                        ReusableText(title: comments.length.toString(),color: whiteColor,weight: FontWeight.w700,),
                        SizedBox(height: 10,),
                        //
                        PopupMenuButton(
                            itemBuilder: (context)=>[
                              PopupMenuItem(
                                  child: video.userId==Provider.of<CurrentUserProvider>(context,listen: false).user!.userId?
                                  TextButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context, builder: (context){
                                         return AlertDialog(
                                           content: Text("Are you sure to delete video"),
                                           actions: [
                                             TextButton(onPressed: ()=>Navigator.pop(context),
                                                 child: Text("No")),
                                             TextButton(onPressed: () async{
                                               await VideoServices().deleteVideo(video.videoId, context);
                                               await getAllVideos();
                                               await getVideoCommentsAndLikes();
                                               setState(() {

                                               });
                                               Navigator.pop(context);
                                             },
                                                 child: Text("Delete"))
                                           ],
                                         );
                                      });

                                    },
                                    child: const Text("Delete"),
                                  ):
                                  TextButton(
                                    onPressed: (){},
                                    child: const Text("About"),
                                  )
                              )
                            ]),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap:(){
                            _showPicker(context: context);
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color: blackColor.withOpacity(0.3),
                            ),
                            child: const Icon(Icons.add_circle_outline_rounded,color: whiteColor,),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  ReusableText(title: "@${"${video.user!.firstName} ${video.user!.lastName}"}",size: 15,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  SizedBox(height: 10,),
                  ReusableText(title: video.description,size: 15,
                    weight: FontWeight.w500,
                    color: whiteColor,
                  ),
                ],
              ),
            ):
                const VideoScreenSkeleton(),
          ],
        );
      },
    );
  }

  void _showPicker({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ReusableTextForm(
                    hintText: 'Write video description here...',
                    controller: descriptionController,
                    maxLine: 3,
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getVideo(ImageSource.gallery);

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getVideo(ImageSource.camera);
                    },
                  ),

                  Center(
                    child: InkWell(
                        onTap: ()async{
                          if(videoFile!=null && descriptionController.text.isNotEmpty){
                            EasyLoading.show(status: "Posting...");
                            bool status=await VideoServices().uploadVideo(videoFile!.path!, descriptionController.text, context);
                            if(status){
                              Get.showSnackbar(const GetSnackBar(message: "Post shared successfully",duration: Duration(seconds: 2),),);
                              updateAllVideos();
                              Navigator.pop(context);

                            }
                            EasyLoading.dismiss();
                            // await Provider.of<CurrentUserProvider>(context,listen: false).uploadProfilePicture(galleryFile!.path, context);
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
            ),
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
          videoFile = xfilePick;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }



  void _showComments({required BuildContext context,required int videoId}) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height*.48,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: Get.height*.4,
                      child:ListView.builder(
                          itemCount: Provider.of<VideoCommentsProvider>(context).videoComments.length,
                          itemBuilder: (context,commentIndex){
                            List<SingleVideoCommentModel> videoComments=Provider.of<VideoCommentsProvider>(context).videoComments;
                            String imageUrl=videoComments[commentIndex].user!.profileImg.replaceAll('public', ApiConstants.baseUrl);
                            return Provider.of<VideoCommentsProvider>(context).videoComments.isNotEmpty?Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: Get.width*.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white
                                  )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),

                                      title: ReusableText(
                                        title: "${videoComments[commentIndex].user!.firstName} ${videoComments[commentIndex].user!.lastName}",
                                        size: 16,
                                        weight: FontWeight.w700,
                                        color: whiteColor,
                                      ),
                                      trailing: PopupMenuButton(
                                          itemBuilder: (context)=>[
                                            PopupMenuItem(
                                                child: videoComments[commentIndex].userId==Provider.of<CurrentUserProvider>(context,listen: false).user!.userId?TextButton(
                                                  onPressed: () async{
                                                    EasyLoading.show(status: 'Deleting');

                                                    bool isDeleted=await VideoCommentServices().deleteVideoComment(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!, videoId, videoComments[commentIndex].commentId, context);
                                                    if(isDeleted){
                                                      Get.showSnackbar(const GetSnackBar(message: "Deleted successfully",duration: Duration(seconds: 2),));
                                                    }
                                                    await updateAllVideos();
                                                    await VideoCommentServices().getAllVideoComments(videoId, context);
                                                    setState(() {

                                                    });
                                                    Navigator.pop(context);
                                                    EasyLoading.dismiss();
                                                  },
                                                  child: const Text("Delete"),
                                                ):TextButton(
                                                  onPressed: () {
                                                    // VideoServices().deleteVideo(videoId, context);
                                                  },
                                                  child: const Text("About"),
                                                )
                                            )
                                          ])
                                  ),
                                  Divider(color: Colors.white,thickness: 1,indent: 30,endIndent: 30,),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(

                                    padding: const EdgeInsets.all(15),
                                    child: ReusableText(title: videoComments[commentIndex].comment,),
                                  )
                                ],
                              ),
                            ):
                            const Center(child: ReusableText(title: "No comments available",color: Colors.white,),);
                          }),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: Get.width*.6,
                          child: ReusableTextForm(

                            hintText: "Write comment here...",
                            filledColor: Colors.white,
                            textColor: Colors.black,
                            controller: commentController,
                            maxLine: 3,
                          ),
                        ),
                        Center(
                          child: InkWell(
                              onTap: ()async{
                                if(commentController.text.isEmpty){
                                  Get.showSnackbar(const GetSnackBar(message: "Can't post empty comment",duration: Duration(seconds: 2),),);
                                }else{
                                  EasyLoading.show(status: 'Posting...');
                                  await VideoCommentServices().commentVideo(
                                      Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!,
                                      videoId, commentController.text, context);
                                  await updateAllVideos();
                                  await VideoCommentServices().getAllVideoComments(videoId, context);
                                  setState(() {

                                  });
                                  EasyLoading.dismiss();
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
                                    child: const Text("Comment",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                              )),
                        )
                      ],
                    ),



                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}