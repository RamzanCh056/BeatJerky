import 'package:beat_jerky/providers/all_categories_provider/all_categories_provider.dart';
import 'package:beat_jerky/providers/chat_provider/chat_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/current_user_feeds_provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feed_comments_provider.dart';
import 'package:beat_jerky/providers/follower_provider/followers_and_following_provider.dart';
import 'package:beat_jerky/providers/music_style_provider/music_style_provider.dart';
import 'package:beat_jerky/providers/users_provider/all_users_provider.dart';
import 'package:beat_jerky/providers/users_provider/current_user_provider.dart';
import 'package:beat_jerky/providers/video_provider/current_user_video_provider.dart';
import 'package:beat_jerky/providers/video_provider/video_comments_provider.dart';
import 'package:beat_jerky/providers/video_provider/video_likes_provider.dart';
import 'package:beat_jerky/providers/video_provider/videos_provider.dart';
import 'package:beat_jerky/screens/splash_screen.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:beat_jerky/providers/feeds_provider/feeds_provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      Provider(create: (_)=>CurrentUserProvider()),
      Provider(create: (_)=>FeedsProvider()),
      Provider(create: (_)=>CommentsProvider()),
      Provider(create: (_)=>VideosProvider()),
      Provider(create: (_)=>VideoCommentsProvider()),
      Provider(create: (_)=>VideoLikesProvider()),
      Provider(create: (_)=>CurrentUserVideoProvider()),
      Provider(create: (_)=>CurrentUserFeedsProvider()),
      Provider(create: (_)=>AllUsersProvider()),
      Provider(create: (_)=>FollowAndFollowingProvider()),
      Provider(create: (_)=>MusicStyleProvider()),
      Provider(create: (_)=>ChatProvider()),
      Provider(create: (_)=>AllCategoriesProvider())


    ],
      child: const MyApp()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        //   colorScheme: ColorScheme.dark(background: blackColor),
        scaffoldBackgroundColor: blackColor,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
