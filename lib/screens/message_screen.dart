
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'package:beat_jerky/model/api_models/chat_model/chat_list_model.dart';
import 'package:beat_jerky/providers/chat_provider/chat_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/services/api_services/chat_services/chat_services.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../model/api_models/user_model/all_users_model.dart';
import '../model/message_model.dart';
import '../providers/users_provider/all_users_provider.dart';
import '../services/api_services/user_services.dart';
import '../shimmer_effect/message_screen_skeleton.dart';
import '../widget/reusable_text.dart';
import '../widget/reusable_textformfield.dart';
import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  TextEditingController searchController=TextEditingController();
  TextEditingController messageController=TextEditingController();
  getAllUsers()async{

    await UserServices().getAllUsers(context);
    allUsers=Provider.of<AllUsersProvider>(context,listen: false).usersList;

    print(allUsers.length);
    setState(() {
      isLoading=false;
    });
  }


  AllUserModel? user;
  List<AllUserModel> allUsers=[];
  List<ChatListModel> chatList=[];
  bool selectRecipient=false;
   bool isLoading=true;
  getChatList()async{
    await ChatServices().getChatList(context);
    chatList=Provider.of<ChatProvider>(context,listen: false).chatList;

    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    getChatList();
    getAllUsers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: indigoColor,
          onPressed: () {
            _showMessageBox(context: context);
          },child: Icon(Icons.message),),
        appBar: AppBar(
          backgroundColor: blackColor,
          title: const ReusableText(
            title: "Messages",
          ),
          actions: const [
            Icon(
              Icons.search,
              color: whiteColor,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: isLoading?const MessageScreenSkeleton():ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: chatList.length,
          itemBuilder: (BuildContext context, int index) {

            return  Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return ChatScreen(
                      receiverId: chatList[index].receiverId,
                      conversationId: chatList[index].conversationId,
                      name: "${chatList[index].receiver.firstName} ${chatList[index].receiver.lastName}",
                      image: chatList[index].receiver.profileImg,status: chatList[index].receiver.isOnline,);
                  }),);
                },
                contentPadding: EdgeInsets.zero,
                leading: chatList[index].receiver.profileImg!=null?CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(chatList[index].receiver.profileImg!.replaceAll('public', ApiConstants.baseUrl)),
                ):const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: Row(
                  children: [
                    ReusableText(title: "${chatList[index].receiver.firstName} ${chatList[index].receiver.lastName}".length>14?"${chatList[index].receiver.firstName} ${chatList[index].receiver.lastName}".substring(0,14):"${chatList[index].receiver.firstName} ${chatList[index].receiver.lastName}",size: 18,color: whiteColor,weight: FontWeight.w700,),
                    SizedBox(width: 10,),
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: chatList[index].receiver.isOnline ? greenColor : greyColor,
                    )
                  ],
                ),
                subtitle: ReusableText(title: chatList[index].message.length>15?chatList[index].message.substring(0,15):chatList[index].message,color: greyColor,),
                trailing: ReusableText(title: chatList[index].createdAt.substring(0,10),color: greyColor,),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMessageBox({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(

          builder: (context, StateSetter setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      selectRecipient==false?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          user!=null?Container(
                            padding: const EdgeInsets.all(5),
                            // height: 30,
                            // width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.white70
                            ),
                            child: ReusableText(title: "${user!.firstName} ${user!.lastName}",color: Colors.black,),
                          ):SizedBox(),
                          InkWell(
                            onTap: ()async{
                              setState(() {
                                selectRecipient=true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(4),
                              height: 30,
                              // width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white70
                              ),
                              child: const ReusableText(title: "Select Recipient",color: Colors.black,),
                            ),
                          ),
                        ],
                      ):
                      const SizedBox(),
                      const SizedBox(height: 5,),
                      Visibility(
                        visible: selectRecipient,
                        child: SizedBox(
                          height: Get.height*.4,
                          width: Get.width,
                          child: ListView.builder(
                            itemCount: allUsers.length,
                              itemBuilder: (context,index){
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
                                                user=allUsers[index];
                                                Get.showSnackbar(GetSnackBar(message: '${allUsers[index].firstName} ${allUsers[index].lastName} Selected',duration: const Duration(seconds: 2),));
                                                setState(() {
                                                  selectRecipient=false;
                                                });
                                              },
                                              child: const ReusableText(title: "Select",color: Colors.black,),
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
                              }),
                        ),
                      ),

                      ReusableTextForm(
                        controller: messageController,
                        hintText: 'Write message here...',
                        maxLine: 3,
                      ),

                      Center(
                        child: InkWell(
                            onTap: ()async{
                             await ChatServices().startMessage(context);
                             int id=Provider.of<ChatProvider>(context,listen: false).startMessageId;
                             if(id != 0){
                               await ChatServices().sendMessage(user!.userId, id, messageController.text, context);
                               await getChatList();
                               setState((){});
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
                                  child: const Text("Send",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                            )),
                      )

                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}
