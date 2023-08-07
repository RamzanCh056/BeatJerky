
import 'dart:ui';
import 'package:beat_jerky/model/api_models/all_categories/all_category_model.dart';
import 'package:beat_jerky/model/api_models/all_categories/all_category_song_model.dart';
import 'package:beat_jerky/providers/all_categories_provider/all_categories_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/repo/api_consts.dart';
import 'package:beat_jerky/screens/drawer/Drawer.dart';
import 'package:beat_jerky/screens/preacher_podcast.dart';
import 'package:beat_jerky/services/api_services/all_categories_services/all_categories_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:beat_jerky/widget/reusable_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:beat_jerky/screens/recommendation_tab.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> type = ["Recommendation", "Trending", "Busniss", "Crypto"];
  int _currentIndex = 0;
  bool initialized=false;
  final List tabs = [
    const RecommendationTab(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  getAllCategories()async{
    await AllCategoriesServices().getAllCategoriesWithSongs(context);
    allCategories=Provider.of<AllCategoriesProvider>(context,listen: false).allCategories;
    setState(() {
      initialized=true;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<AllCategoriesModel> allCategories=[];

  @override
  void initState() {
    getAllCategories();
    EasyLoading.dismiss();
    // TODO: implement initState
    super.initState();
  }
  void controlMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openDrawer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
     drawer: const Drawer(

       child: DrawerScreen(),
     ),



  body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    GestureDetector(
                      onTap:(){
                      //  Scaffold.of(context).openDrawer();
                        scaffoldKey.currentState!.openDrawer();
                      },
                        child: const Icon(Icons.menu, size: 26,)),
                    ReusableText(
                      title: "Hello ${Provider.of<CurrentUserProvider>(context).user!.firstName} ${Provider.of<CurrentUserProvider>(context).user!.lastName},",
                      size: 18,
                      weight: FontWeight.w700,
                      color: whiteColor,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return const MessageScreen();
                          }));
                        },
                        child: const Icon(FontAwesomeIcons.solidCommentDots,color: whiteColor,size: 26,)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const ReusableText(
                  title: "What you want to hear today",
                  size: 15,
                  weight: FontWeight.w400,
                  color: greyColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                const ReusableTextForm(
                  hintText: "Search Podcast",
                  prefixIcon: Icon(
                    Icons.search,
                    color: greyColor,
                  ),
                  suffixIcon: Icon(
                    Icons.filter_list_outlined,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Get.width*.9,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: allCategories.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            child: Column(
                              children: [
                                ReusableText(
                                  title: allCategories[index].categoryName,
                                  size: 16,
                                  color: whiteColor,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 3,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    gradient: _currentIndex == index
                                        ? const LinearGradient(
                                      colors: [
                                        indigoColor,
                                        pinkColor,
                                      ],
                                    )
                                        : const LinearGradient(
                                      colors: [
                                        transparentColor,
                                        transparentColor,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          initialized?SizedBox(
            height: Get.height*.578,
            child: ListView.builder(
              itemCount: allCategories[_currentIndex].songs.length,
                itemBuilder: (context,index){
                CategoriesSongModel song=CategoriesSongModel.fromJson(allCategories[_currentIndex].songs[index]);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightBlackColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: song.coverImageURL!=null?Image.network(
                              song.coverImageURL!.replaceAll('public', ApiConstants.baseUrl),
                              fit: BoxFit.cover,
                            ):Image.asset('assets/images/logo.png'),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                title: song.title.length>20?song.title.substring(0,20):song.title,
                                weight: FontWeight.w700,
                                color: whiteColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ReusableText(
                                title: song.singer,
                                size: 15,
                                weight: FontWeight.w400,
                                color: greyColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                    title: song.createdAt.substring(0,10),
                                    size: 15,
                                    weight: FontWeight.w400,
                                    color: greyColor,
                                  ),
                                  InkWell(
                                    onTap:()async{
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        // return PreacherPodcast(song: song,);
                                        return AudioPlay(song: song,);
                                      }),);
                                      // await player.play(source)
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: buttonGradient,
                                      ),
                                      child: const Icon(Icons.play_arrow,color: whiteColor,),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ):const Center(child: CircularProgressIndicator()),
        ],
      ),
    );


  }

}
