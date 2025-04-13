import 'package:get/get.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_controller.dart';
import 'package:music_playlist_app/services/music/services.dart';

class PlaylistScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PlaylistScreenController.new, fenix: true);
    Get.lazyPut(MusicService.new, fenix: true);
  }

}