import 'package:get/get.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_binding.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_view.dart';
import 'package:music_playlist_app/router/route_path.dart';

abstract class Routes {
  static List<GetPage> routers = [
    GetPage(
      name: RoutePath.playlistPath,
      page: PlaylistScreen.new,
      transition: Transition.native,
      binding: PlaylistScreenBinding()
    ),
    // GetPage(
    //   name: RoutePath.cartPath,
    //   page: CartScreen.new,
    //   transition: Transition.native,
    //   binding: CartBinding()
    // ),
  ];
}