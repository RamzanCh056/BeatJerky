


class ConversationModelFields{
  static const String id='id';
  static const String senderId='senderId';
  static const String receiverId='receiverId';
  static const String conversationId='conversationId';
  static const String message='message';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
}


class ConversationModel{
  int id;
  int senderId;
  int receiverId;
  int conversationId;
  String message;
  String createdAt;
  String updatedAt;


  ConversationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,

  });

  factory ConversationModel.fromJson(Map<String,dynamic> json)=>ConversationModel(
    id: json[ConversationModelFields.id],
    senderId: json[ConversationModelFields.senderId],
    receiverId: json[ConversationModelFields.receiverId],
    conversationId: json[ConversationModelFields.conversationId],
    message: json[ConversationModelFields.message],
    createdAt: json[ConversationModelFields.createdAt],
    updatedAt: json[ConversationModelFields.updatedAt],
  );



}