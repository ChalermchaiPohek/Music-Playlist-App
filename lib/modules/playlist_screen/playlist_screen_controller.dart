import 'package:get/get.dart';
import 'package:music_playlist_app/models/album.dart';
import 'package:music_playlist_app/services/music/services.dart';

class PlaylistScreenController extends GetxController {
  final MusicService _musicService = Get.find();

  final Rxn<Album> _album = Rxn();
  Album? get fetchAlbum => _album.value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();//
    try {
      _getAlbum();
    } catch (error, s) {
      print(s.toString());
      _isLoading.value = false;
    }
  }

  Future _getAlbum() async {
    final fetchAlbum = await _musicService.getAlbum();
    _isLoading.value = false;
    _album.value = fetchAlbum;
  }
}