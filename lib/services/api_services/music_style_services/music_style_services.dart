import 'dart:convert';

import 'package:beat_jerky/model/api_models/music_style_models/music_style_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;

import 'package:beat_jerky/providers/music_style_provider/music_style_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/api_models/all_categories/all_category_song_model.dart';
import '../../../repo/api_consts.dart';
import '../../../repo/api_services.dart';

class MusicStyleServices{


  getMusicStyles(BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getAllMusicStyles}";
    Map<String ,dynamic> body={

    };

    print(uri);
    print(header);
    http.Response response=await ApiServices().getService(uri:uri,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List dataList=data['data'];
      List<MusicStyleModel> musicList=[];
      for(int i=0;i<dataList.length;i++){
        musicList.add(MusicStyleModel.fromJson(dataList[i]));
      }
      Provider.of<MusicStyleProvider>(context,listen: false).updateMusicStyleList(musicList);
      print(response.body);
      print(response.body);
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }

  getMusicStylesById(int id,BuildContext context)async{

    var header= {
      'Content-Type':'application/json',
    };

    String uri="${ApiConstants.baseUrl}${ApiConstants.getMusicStylesById}$id";
    Map<String ,dynamic> body={

    };

    print(uri);
    print(header);
    http.Response response=await ApiServices().getService(uri:uri,header: header);
    print(response.body);
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      List dataList=data['data'];
      List<CategoriesSongModel> songsList=[];
      for(int i=0;i<dataList.length;i++){
        songsList.add(CategoriesSongModel.fromJson(dataList[i]));
      }
      Provider.of<MusicStyleProvider>(context,listen: false).updateSongsInCategoryList(songsList);
      print(response.body);
      print(response.body);
      return true;
    }else{
      EasyLoading.showError(response.statusCode.toString());
      return false;
    }


  }





}