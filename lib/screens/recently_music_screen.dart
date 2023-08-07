import 'package:beat_jerky/providers/music_style_provider/music_style_provider.dart';
import 'package:beat_jerky/screens/preacher_podcast.dart';
import 'package:beat_jerky/services/api_services/music_style_services/music_style_services.dart';
import 'package:beat_jerky/shimmer_effect/recently_music_screen_skeleton.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/api_models/all_categories/all_category_song_model.dart';
import '../model/recently_music.dart';

class RecentlyMusicScreen extends StatefulWidget {
  const RecentlyMusicScreen({required this.id,Key? key}) : super(key: key);
  final int id;
  @override
  State<RecentlyMusicScreen> createState() => _RecentlyMusicScreenState();
}

class _RecentlyMusicScreenState extends State<RecentlyMusicScreen> {
  final List<RecentlyMusicModel> recentlyData = [
    RecentlyMusicModel(
        title: 'Post Malone',
        subTitle: 'Chemical',
        image:
            "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    RecentlyMusicModel(
        title: 'Yng Lvcas',
        subTitle: 'La Bebe',
        image:
            "https://images.unsplash.com/photo-1471478331149-c72f17e33c73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80"),
    RecentlyMusicModel(
        title: 'TAEYANG',
        subTitle: 'Seed.id',
        image:
            "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    RecentlyMusicModel(
        title: 'Post Malone',
        subTitle: 'Chemical',
        image:
            "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
    RecentlyMusicModel(
        title: 'Yng Lvcas',
        subTitle: 'La Bebe',
        image:
            "https://images.unsplash.com/photo-1471478331149-c72f17e33c73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80"),
    RecentlyMusicModel(
        title: 'TAEYANG',
        subTitle: 'Seed.id',
        image:
            "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
  ];

  bool isLoading=true;
  getMusicById()async{
    await MusicStyleServices().getMusicStylesById(widget.id, context);
    songsList=Provider.of<MusicStyleProvider>(context,listen: false).songsInCategoryList;
    setState(() {
      isLoading=false;
    });

  }

  List<CategoriesSongModel> songsList=[];

  @override
  void initState() {
    getMusicById();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: blackColor,
          title: const ReusableText(
            title: "Recently Music",
          ),
        ),
        body: isLoading?const RecentlyMusicScreenSkeleton():ListView.builder(
          padding: const EdgeInsets.all(14),
          shrinkWrap: true,
          itemCount: songsList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  // return PreacherPodcast(song: song,);
                  return AudioPlay(song: songsList[index],);
                }),);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    ReusableText(
                      title: index.toString(),
                      size: 18,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 60,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: songsList[index].coverImageURL!=null?DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(songsList[index].coverImageURL!),
                        ):const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          title: songsList[index].title,
                          color: whiteColor,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        ReusableText(
                          title: songsList[index].descriptionOfSong.length>10?"${songsList[index].descriptionOfSong.substring(0,11)}...":songsList[index].descriptionOfSong,
                          color: greyColor,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert,color: whiteColor,),
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
