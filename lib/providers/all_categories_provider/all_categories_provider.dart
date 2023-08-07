


import 'package:flutter/cupertino.dart';

import '../../model/api_models/all_categories/all_category_model.dart';

class AllCategoriesProvider extends ChangeNotifier{
  List<AllCategoriesModel> allCategories=[];

  updateAllCategories(List<AllCategoriesModel> list){
    allCategories=list;
    notifyListeners();
  }
}