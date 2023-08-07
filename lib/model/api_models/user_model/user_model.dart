


class UserModelFields{
  static const String userId='userId';
  static const String firstName='firstName';
  static const String lastName='lastName';
  static const String email='email';
  static const String imageUrl='imageUrl';
  static const String admin='admin';
}

class UserModel{
  int? userId;
  String firstName;
  String lastName;
  String email;
  String? imageUrl;
  bool? admin;

  UserModel({
    this.userId,
   required this.firstName,
   required this.lastName,
   required this.email,
   this.admin,
    this.imageUrl
});

  factory UserModel.fromJson(Map<String,dynamic> json)=>UserModel(
      userId: json[UserModelFields.userId]??0,
      firstName: json[UserModelFields.firstName]??'First Name',
      lastName: json[UserModelFields.lastName]??'Last Name',
      email: json[UserModelFields.email]??'Email',
      admin: json[UserModelFields.admin]??false
  );

}