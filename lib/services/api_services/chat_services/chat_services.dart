
import 'dart:convert';

import 'package:beat_jerky/model/api_models/chat_model/chat_list_model.dart';
import 'package:beat_jerky/model/api_models/chat_model/conversation_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/current_user_feed_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/providers/chat_provider/chat_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/current_user_feeds_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../../model/api_models/user_model/user_model.dart';
import '../../../providers/users_provider/current_user_provider.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class ChatServices{


  getChatList(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getChatList}${Provider.of<CurrentUserProvider>(context,listen: false).user!.userId}";

    print(uri);
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedsMap=data['data'];
      print(response.body);
      print(feedsMap.length);

      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<ChatListModel> chatList=[];
      for(int i=0; i<feedsMap.length;i++){

        chatList.add(ChatListModel.fromJson(feedsMap[i]));
      }
      print(chatList.length);
      Provider.of<ChatProvider>(context,listen: false).updateChatList(chatList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  getConversation(int conversationId,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getConversationById}$conversationId";

    print(uri);
    http.Response response=await ApiServices().getService(uri:uri,header: header);

    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List feedsMap=data['data'];
      print(response.body);
      print(feedsMap.length);

      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      List<ConversationModel> chatList=[];
      for(int i=0; i<feedsMap.length;i++){

        chatList.add(ConversationModel.fromJson(feedsMap[i]));
      }
      print(chatList.length);
      Provider.of<ChatProvider>(context,listen: false).updateConversation(chatList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  sendMessage(int receiverId,int conversationId,String message,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    Map<String,dynamic> body={
      "senderId":Provider.of<CurrentUserProvider>(context,listen: false).user!.userId,
      "receiverId":receiverId,
      "conversationId":conversationId,
      "text": message
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.message}";

    print(uri);
    http.Response response=await ApiServices().postService(uri:uri,body:body,header: header);

    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);


      // print(feedsMap);
      // imageUrl=imageUrl.replaceAll('public', ApiConstants.baseUrl);


      // List<ChatListModel> chatList=[];
      // for(int i=0; i<feedsMap.length;i++){
      //
      //   chatList.add(ChatListModel.fromJson(feedsMap[i]));
      // }
      // print(chatList.length);
      // Provider.of<ChatProvider>(context,listen: false).updateChatList(chatList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  startMessage(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    Map<String,dynamic> body={
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.startChat}";

    print(uri);
    http.Response response=await ApiServices().postService(uri:uri,body: body,header: header);

    EasyLoading.dismiss();
    print(response.body);
    print(response.statusCode);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      int id=data['data']['id'];
      print(id);
      Provider.of<ChatProvider>(context,listen: false).updateStartMessageId(id);

    }else{
      EasyLoading.showError(response.statusCode.toString());
    }


  }




}