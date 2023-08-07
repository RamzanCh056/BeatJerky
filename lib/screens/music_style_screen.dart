import 'package:beat_jerky/model/api_models/music_style_models/music_style_model.dart';
import 'package:beat_jerky/providers/music_style_provider/music_style_provider.dart';
import 'package:beat_jerky/screens/recently_music_screen.dart';
import 'package:beat_jerky/services/api_services/music_style_services/music_style_services.dart';
import 'package:beat_jerky/shimmer_effect/music_style_screen_skeleton.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/music_model.dart';

class MusicStyle extends StatefulWidget {
  const MusicStyle({Key? key}) : super(key: key);

  @override
  State<MusicStyle> createState() => _MusicStyleState();
}

class _MusicStyleState extends State<MusicStyle> {
  final List<MusicModel> musicData = [
    MusicModel(
        name: "Rap Gangs",
        image:
            "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    MusicModel(
        name: "Rap Party",
        image:
            "https://images.unsplash.com/photo-1471478331149-c72f17e33c73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80"),
    MusicModel(
        name: "Hip Hop Now",
        image:
            "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    MusicModel(
        name: "Rap Dizz",
        image:
            "https://images.unsplash.com/photo-1465821185615-20b3c2fbf41b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=998&q=80"),
    MusicModel(
        name: "Hip Hop Now",
        image:
            "https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    MusicModel(
        name: "Rap Party",
        image:
        "https://images.unsplash.com/photo-1471478331149-c72f17e33c73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80"),

  ];

  List<MusicStyleModel> musicStyleList=[];
  getAllMusicStyles()async{
    await MusicStyleServices().getMusicStyles(context);
    musicStyleList=Provider.of<MusicStyleProvider>(context,listen: false).musicStyleList;
    setState(() {
      isLoading=false;
    });
  }

  bool isLoading=true;
  @override
  void initState() {
    getAllMusicStyles();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blackColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const ReusableText(
            title: "Music Style",
          ),
        ),
      body: isLoading?const MusicStyleSkeleton():
      GridView.builder(
          itemCount: musicStyleList.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return RecentlyMusicScreen(id: musicStyleList[index].id,);
                }));
              },
              child: Container(
                // height: 170,
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/images/logo.png'),
                  //     fit: BoxFit.cover),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/logo.png',height: 78,width: 78,),
                    const Icon(Icons.play_circle_outline,color: whiteColor,size: 30,),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: blackColor.withOpacity(0.6),
                        ),
                        child
                        : ReusableText(title: musicStyleList[index].musicStyleName,size: 18,weight: FontWeight.w700,color: Colors.white,))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
