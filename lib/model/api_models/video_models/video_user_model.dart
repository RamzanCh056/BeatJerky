


class VideoUserModelFields{

  static const String firstName='firstName';
  static const String lastName='lastName';


}

class VideoUserModel{

  String firstName;
  String lastName;


  VideoUserModel({

    required this.firstName,
    required this.lastName,

  });

  factory VideoUserModel.fromJson(Map<String,dynamic> json)=>VideoUserModel(

      firstName: json[VideoUserModelFields.firstName]??'First Name',
      lastName: json[VideoUserModelFields.lastName]??'Last Name',

  );

}