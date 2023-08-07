


class FeedUserModelFields{

  static const String firstName='firstName';
  static const String lastName='lastName';

}

class FeedUserModel{

  String firstName;
  String lastName;


  FeedUserModel({

    required this.firstName,
    required this.lastName,

  });

  factory FeedUserModel.fromJson(Map<String,dynamic> json)=>FeedUserModel(

      firstName: json[FeedUserModelFields.firstName]??'First Name',
      lastName: json[FeedUserModelFields.lastName]??'Last Name',

  );

}