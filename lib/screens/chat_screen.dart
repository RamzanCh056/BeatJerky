import 'dart:async';

import 'package:beat_jerky/model/api_models/chat_model/conversation_model.dart';
import 'package:beat_jerky/providers/chat_provider/chat_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../services/api_services/chat_services/chat_services.dart';
import '../widget/build_message.dart';


class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String? image;
  final String name;
  final bool status;
  final int receiverId;
  const ChatScreen({Key? key,required this.receiverId,required this.conversationId, required this.image, required this.name, required this.status}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController=TextEditingController();

  List<ConversationModel> conversationList=[];
  getConversation()async{
    await ChatServices().getConversation(widget.conversationId, context);
    conversationList=Provider.of<ChatProvider>(context,listen: false).conversationList;
    setState(() {

    });
  }

  @override
  void initState() {
    getConversation();
    Timer.periodic(
        const Duration(seconds: 30), (timer) {getConversation();});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: RefreshIndicator(
      onRefresh: ()=>getConversation(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blackColor,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: widget.image==null?const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ):CircleAvatar(
              backgroundImage: NetworkImage(widget.image!.replaceAll('public', ApiConstants.baseUrl)),


            ),
            title: ReusableText(title: widget.name,color: whiteColor,),
            subtitle: ReusableText(title: widget.status ? "online" : "offline",color: greyColor,),
          ),
          actions: const [
            Icon(Icons.more_vert,color: whiteColor,),
            SizedBox(width: 10,),
          ],
        ),
        body:  Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: conversationList.length,
                  itemBuilder: (context,index){
                    return BuildMessage(message: conversationList[index].message,isMe: conversationList[index].senderId==Provider.of<CurrentUserProvider>(context).user!.userId,);
                  },
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: backgroundColor,
              child: TextField(
                controller: messageController,
                style: const TextStyle(color: whiteColor),
                decoration: InputDecoration(
                  hintText: "write your message",
                  hintStyle: const TextStyle(color: whiteColor),
                  suffixIcon: InkWell(
                      onTap: ()async{
                        if(messageController.text.isNotEmpty) {
                          await ChatServices().sendMessage(widget.receiverId, widget.conversationId, messageController.text, context);
                          messageController.clear();
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          getConversation();
                          setState(() {

                          });
                        }
                      },
                      child: messageController.text.isEmpty?const Icon(Icons.send,color: greyColor,):
                      const Icon(Icons.send,color: whiteColor,)
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )
                ),
              ),
            )
          ],
        )
      ),
    ),);
  }
}



