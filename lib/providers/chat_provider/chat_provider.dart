


import 'package:beat_jerky/model/api_models/chat_model/chat_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../model/api_models/chat_model/conversation_model.dart';

class ChatProvider extends ChangeNotifier{

  int startMessageId=0;
  List<ChatListModel> chatList=[];
  List<ConversationModel> conversationList=[];


  updateStartMessageId(int id){
    startMessageId=id;
    notifyListeners();
  }

  updateConversation(List<ConversationModel> conversation){
    conversationList=conversation;
    notifyListeners();
  }

  updateChatList(List<ChatListModel> chat){
    chatList=chat;
    notifyListeners();
  }


}