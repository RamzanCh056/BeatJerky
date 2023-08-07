import 'dart:io';

import 'package:beat_jerky/model/api_models/feed_models/feed_comments_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_likes_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/single_feed_comments_model.dart';
import 'package:beat_jerky/providers/feeds_provider/feed_comments_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/services/api_services/feed_services/feed_comment_services.dart';
import 'package:beat_jerky/services/api_services/feed_services/feed_services.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/shimmer_effect/feed_skeleton.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:beat_jerky/widget/reusable_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/api_services/feed_services/feed_like_services.dart';
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  TextEditingController descriptionController=TextEditingController();
  TextEditingController commentController=TextEditingController();

  File? videoFile;
  File? galleryFile;
  final picker = ImagePicker();
  bool isVideo = true;
  bool isPic = false;


  getAllFeeds()async{
    await FeedServices().getAllFeeds(context);
    EasyLoading.dismiss();
    setState(() {
      isLoading=false;
    });
  }

  bool isLoading=true;
  updateAllFeeds()async{
    await FeedServices().getAllFeeds(context);
    setState(() {

    });
  }


  @override
  void initState() {
    getAllFeeds();
    // TODO: implement initState
    super.initState();
  }



  List<FeedModel> feedList=[];
  List<int> listOfLikedFeedsIndex=[];


  @override
  Widget build(BuildContext context) {
    var feedProvider=Provider.of<FeedsProvider>(context);

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
                _showPicker(context: context);
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
        body: isLoading?
            ListView.builder(
                itemCount: 4,
                itemBuilder: (context,index){
                  return const FeedSkeleton();
                })
            :ListView.builder(
          itemCount: feedProvider.feedsList.length,
          itemBuilder: (BuildContext context, int index) {
            String imageUrl=feedProvider.feedsList[index].imageUrl.replaceAll('public', ApiConstants.baseUrl);

            /// This is the complete list of likes at the current index
            List<FeedLikesModel> feedLikes=[];
            var user = Provider.of<CurrentUserProvider>(context).user;
            /// This is used as a flag for identification of feed like by
            /// current user this list only have one item
            List<FeedLikesModel> feedLike=[];
            /// This is the index of like in the main feed at the above index
            /// field this list will have only one item
            List<int> indexOfFeedLike=[];
            /// This is the index of like in the main feed at the above index
            /// field this list will have only one item
            List<int> indexOfFeedComments=[];

            /// This is the complete lists of comment on the feed at index
            List<FeedCommentModel> feedComments=[];
            /// This is used as a flag for identification of feed like by
            /// current user this list only have one item
            List<FeedCommentModel> feedComment=[];
            bool feedLiked=false;
            print("I am build call");

            for(int i=0; i<feedProvider.feedsList[index].feedLikes.length;i++){
              feedLikes.add(FeedLikesModel.fromJson(feedProvider.feedsList[index].feedLikes[i]));
              if(feedProvider.feedsList[index].feedLikes[i]['userId']==user!.userId){
                feedLike.add(FeedLikesModel.fromJson(feedProvider.feedsList[index].feedLikes[i]));
                listOfLikedFeedsIndex.add(index);
                indexOfFeedLike.add(i);

              }
              // if(feedLikes[i].)
            }
            if(feedLike.isNotEmpty){
              feedLiked=true;
            }
            for(int i=0; i<feedProvider.feedsList[index].feedComments.length;i++){
              feedComments.add(FeedCommentModel.fromJson(feedProvider.feedsList[index].feedComments[i]));
              if(feedProvider.feedsList[index].feedComments[i]['userId']==user!.userId){
                feedComment.add(FeedCommentModel.fromJson(feedProvider.feedsList[index].feedComments[i]));
                indexOfFeedComments.add(i);


              }
              // if(feedLikes[i].)
            }


            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: ReusableText(
                      title: "${feedProvider.feedsList[index].user!.firstName} ${feedProvider.feedsList[index].user!.lastName}",
                      size: 16,
                      weight: FontWeight.w700,
                      color: whiteColor,
                    ),
                    trailing: PopupMenuButton(
                        itemBuilder: (context)=>[
                          PopupMenuItem(
                              child: feedProvider.feedsList[index].userId==Provider.of<CurrentUserProvider>(context,listen: false).user!.userId?TextButton(
                                onPressed: () async{
                                  EasyLoading.show(status: 'Deleting');
                                  bool isDeleted=await FeedServices().deleteFeed(feedProvider.feedsList[index].feedId, context);
                                  if(isDeleted){
                                    Get.showSnackbar(const GetSnackBar(message: "Deleted successfully",duration: Duration(seconds: 2),));
                                    updateAllFeeds();

                                  }
                                  Navigator.pop(context);
                                  EasyLoading.dismiss();
                                },
                                child: const Text("Delete"),
                              ):TextButton(
                                onPressed: () {
                                  // FeedServices().deleteFeed(feedProvider.feedsList[index].feedId, context);
                                },
                                child: const Text("About"),
                              )
                          )
                        ])
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // NetworkImage(imageUrl),
                  Image.network(imageUrl),
                  // FadeInImage(
                  //     placeholder: const AssetImage('assets/images/beet.jpg'),
                  //     image: NetworkImage(imageUrl)),

                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: ()async{

                                      print("Button pressed");
                                      print(listOfLikedFeedsIndex.length);
                                      print(listOfLikedFeedsIndex.isNotEmpty);
                                      print(listOfLikedFeedsIndex.contains(index));
                                      print("=============+><+=================");
                                      if(listOfLikedFeedsIndex.isNotEmpty && listOfLikedFeedsIndex.contains(index)){
                                        print(index);
                                        print(listOfLikedFeedsIndex.remove(index));
                                        setState(() {
                                          listOfLikedFeedsIndex.remove(index);
                                        });
                                        print(feedLike.length);

                                        await FeedLikeServices().dislikeFeedLike(
                                            user!.userId!,
                                            feedProvider.feedsList[index].feedId,
                                            index,
                                            feedLike[0].likeId,
                                            indexOfFeedLike[0],
                                            context);
                                        setState(() {});
                                      }else{

                                        bool like=await FeedLikeServices().likeFeed(
                                            user!.userId!,
                                            feedProvider.feedsList[index].feedId,
                                            index,
                                            context);
                                      }
                                      updateAllFeeds();

                                    },
                                    child: listOfLikedFeedsIndex.contains(index) && feedLiked?const Icon(Icons.favorite,color: redColor,):
                                    const Icon(Icons.favorite,color: Colors.white,)),
                                Text(feedLike.isEmpty?0.toString():feedLike.length.toString())
                              ],
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                InkWell(
                                    onTap: ()async{
                                      await FeedCommentServices().getAllComments(feedProvider.feedsList[index].feedId, context);
                                      setState(() {

                                      });
                                      _showComments(context: context,feedId: feedProvider.feedsList[index].feedId);
                                    },
                                    child: const Icon(Icons.messenger_outline,color: Colors.white,)),
                                Text(feedComment.isEmpty?0.toString():feedComment.length.toString())
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.bookmark_border,color: whiteColor,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        ReusableText(title:feedProvider.feedsList[index].description,color: whiteColor,size: 15,weight: FontWeight.w400,),
                        const SizedBox(height: 10,),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
                    controller: descriptionController,
                    hintText: 'Write description here...',
                    maxLine: 3,
                  ),
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
                          if(galleryFile!=null && descriptionController.text.isNotEmpty){
                            EasyLoading.show(status: "Posting...");
                            bool status=await FeedServices().uploadFeed(galleryFile!.path, descriptionController.text, context);
                            if(status){
                              Get.showSnackbar(const GetSnackBar(message: "Post shared successfully",duration: Duration(seconds: 2),),);
                              updateAllFeeds();
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

  void _showComments({required BuildContext context,required int feedId}) {

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
                        itemCount: Provider.of<CommentsProvider>(context).feedComments.length,
                          itemBuilder: (context,commentIndex){
                          List<SingleFeedCommentModel> feedComments=Provider.of<CommentsProvider>(context).feedComments;
                          String imageUrl=feedComments[commentIndex].user!.profileImg.replaceAll('public', ApiConstants.baseUrl);
                            return Provider.of<CommentsProvider>(context).feedComments.isNotEmpty?Container(
                              margin: EdgeInsets.only(bottom: 10),
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
                                        title: "${feedComments[commentIndex].user!.firstName} ${feedComments[commentIndex].user!.lastName}",
                                        size: 16,
                                        weight: FontWeight.w700,
                                        color: whiteColor,
                                      ),
                                      trailing: PopupMenuButton(
                                          itemBuilder: (context)=>[
                                            PopupMenuItem(
                                                child: feedComments[commentIndex].userId==Provider.of<CurrentUserProvider>(context,listen: false).user!.userId?TextButton(
                                                  onPressed: () async{
                                                    EasyLoading.show(status: 'Deleting');

                                                    bool isDeleted=await FeedCommentServices().deleteFeedComment(Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!, feedId, feedComments[commentIndex].commentId, context);
                                                    if(isDeleted){
                                                      Get.showSnackbar(const GetSnackBar(message: "Deleted successfully",duration: Duration(seconds: 2),));
                                                    }
                                                    await updateAllFeeds();
                                                    await FeedCommentServices().getAllComments(feedId, context);
                                                    setState(() {

                                                    });
                                                    Navigator.pop(context);
                                                    EasyLoading.dismiss();
                                                  },
                                                  child: const Text("Delete"),
                                                ):TextButton(
                                                  onPressed: () {
                                                    // FeedServices().deleteFeed(feedProvider.feedsList[index].feedId, context);
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
                                    child: ReusableText(title: feedComments[commentIndex].comment,),
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
                                  await FeedCommentServices().commentFeed(
                                      Provider.of<CurrentUserProvider>(context,listen: false).user!.userId!,
                                      feedId, commentController.text, context);
                                  await updateAllFeeds();
                                  await FeedCommentServices().getAllComments(feedId, context);
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
          if(pickedFile!.name.endsWith('jpg')||pickedFile.name.endsWith('png')||pickedFile.name.endsWith('jpeg')) {
            galleryFile = File(pickedFile.path);
          }else{
            Get.showSnackbar(const GetSnackBar(message: "Only jpg,jpeg and png file is supported",duration: Duration(seconds: 2),),);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

}

