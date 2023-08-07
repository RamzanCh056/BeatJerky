


import 'package:beat_jerky/model/api_models/all_categories/all_category_song_model.dart';

class AllCategoriesModelFields{
  static const String id='id';
  static const String categoryName='categoryName';
  static const String categoryDescription='categoryDescription';
  static const String createdAt='createdAt';
  static const String updatedAt='updatedAt';
  static const String songs='songs';
}

class AllCategoriesModel{
  final int id;
  final String categoryName;
  final String categoryDescription;
  final String createdAt;
  final String updatedAt;
  final List songs;

  AllCategoriesModel({
    required this.id,
    required this.categoryName,
    required this.categoryDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.songs ,
});

  factory AllCategoriesModel.fromJson(Map<String,dynamic> json)=>AllCategoriesModel(
      id: json[AllCategoriesModelFields.id],
      categoryName: json[AllCategoriesModelFields.categoryName],
      categoryDescription: json[AllCategoriesModelFields.categoryDescription],
      createdAt: json[AllCategoriesModelFields.createdAt],
      updatedAt: json[AllCategoriesModelFields.updatedAt],
      songs: json[AllCategoriesModelFields.songs]
  );

}