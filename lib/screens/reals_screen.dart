import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';
import '../player/video_player.dart';
import '../providers/video_provider/videos_provider.dart';
import '../services/api_services/video_services/video_services.dart';

class PreloadPage extends StatefulWidget {
  const PreloadPage({Key? key}) : super(key: key);

  @override
  State<PreloadPage> createState() => _PreloadPageState();
}

class _PreloadPageState extends State<PreloadPage> {

  getAllVideos()async{

    await VideoServices().getAllVideos(context);

    setState(() {

    });
  }

  @override
  void initState() {
    getAllVideos();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose(){
    //...
    Provider.of<VideosProvider>(context,listen: false).videosList.clear();
    setState(() {

    });
    super.dispose();
    //...
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VideoController());
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: PreloadPageView.builder(
            itemBuilder: (ctx, i) {
              return Player(i: i);
            },
            onPageChanged: (i) async {
              c.updateAPI(i);
            },
            //If you are increasing or descrising preaload page count change accordingly in the player widget
            preloadPagesCount: 1,
            controller: PreloadPageController(initialPage: 0),
            itemCount: Provider.of<VideosProvider>(context,listen: false).videosList.length,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }



}