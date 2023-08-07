



class SenderReceiverModelFields{
  static const String firstName='firstName';
  static const String lastName='lastName';
  static const String profileImg='profileImg';
  static const String isOnline='isOnline';
  static const String lastOnline='lastOnline';
}

class SenderReceiverModel{
  String firstName;
  String lastName;
  String? profileImg;
  bool isOnline;
  String lastOnline;

  SenderReceiverModel({
    required this.firstName,
    required this.lastName,
    required this.profileImg,
    required this.isOnline,
    required this.lastOnline,
});

  factory SenderReceiverModel.fromJson(Map<String,dynamic> json)=>SenderReceiverModel(
      firstName: json[SenderReceiverModelFields.firstName],
      lastName: json[SenderReceiverModelFields.lastName],
      profileImg: json[SenderReceiverModelFields.profileImg],
      isOnline: json[SenderReceiverModelFields.isOnline]??false,
      lastOnline: json[SenderReceiverModelFields.lastOnline]??''
  );

}