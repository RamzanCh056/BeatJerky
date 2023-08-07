
import 'dart:convert';

import 'package:beat_jerky/model/api_models/all_categories/all_category_model.dart';
import 'package:beat_jerky/model/api_models/chat_model/chat_list_model.dart';
import 'package:beat_jerky/model/api_models/chat_model/conversation_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/current_user_feed_model.dart';
import 'package:beat_jerky/model/api_models/feed_models/feed_model.dart';
import 'package:beat_jerky/providers/all_categories_provider/all_categories_provider.dart';
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

class AllCategoriesServices{


  getAllCategoriesWithSongs(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.allCategoriesWithSongs}";

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


      List<AllCategoriesModel> allCategoriesList=[];
      for(int i=0; i<feedsMap.length;i++){

        allCategoriesList.add(AllCategoriesModel.fromJson(feedsMap[i]));
      }
      print(allCategoriesList.length);
      Provider.of<AllCategoriesProvider>(context,listen: false).updateAllCategories(allCategoriesList);
      EasyLoading.dismiss();
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }
  }

}