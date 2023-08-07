


import 'package:beat_jerky/model/api_models/chat_model/sender_receiver_model.dart';

class ChatListModelFields{
  static const String id='id';
  static const String senderId='senderId';
  static const String receiverId='receiverId';
  static const String conversationId='conversationId';
  static const String message='message';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
  static const String sender='sender';
  static const String receiver='receiver';
}

class ChatListModel{
  int id;
  int senderId;
  int receiverId;
  int conversationId;
  String message;
  String createdAt;
  String updatedAt;
  SenderReceiverModel sender;
  SenderReceiverModel receiver;


  ChatListModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    required this.receiver
});

  factory ChatListModel.fromJson(Map<String,dynamic> json)=>ChatListModel(
      id: json[ChatListModelFields.id],
      senderId: json[ChatListModelFields.senderId],
      receiverId: json[ChatListModelFields.receiverId],
      conversationId: json[ChatListModelFields.conversationId],
      message: json[ChatListModelFields.message],
      createdAt: json[ChatListModelFields.createdAt],
      updatedAt: json[ChatListModelFields.updatedAt],
      sender: SenderReceiverModel.fromJson(json[ChatListModelFields.sender]),
    receiver: SenderReceiverModel.fromJson(json[ChatListModelFields.receiver]),
  );



}