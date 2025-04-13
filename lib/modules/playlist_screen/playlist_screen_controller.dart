import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:music_playlist_app/models/album.dart';
import 'package:music_playlist_app/services/music/services.dart';

class PlaylistScreenController extends GetxController {
  final MusicService _musicService = Get.find();

  // final Rxn<Album> _album = Rxn();
  // Album? get fetchAlbum => _album.value;
  late final RxList<AlbumData> _albumList = RxList<AlbumData>();
  List<AlbumData> get fetchAlbum => _albumList;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _isFetchNextData = false.obs;
  bool get isFetchNextData => _isFetchNextData.value;

  @override
  Future onInit() async {
    super.onInit();//
    try {
      await _getAlbum();
    } catch (error, s) {
      if (kDebugMode) {
        print(s.toString());
      }
      _isLoading.value = false;
    }
  }

  Future _getAlbum() async {
    final fetchAlbum = await _musicService.getAlbum();
    _isLoading.value = false;
    _albumList.value = fetchAlbum.results ?? <AlbumData>[];
  }

  Future getNextAlbum() async {
    _isFetchNextData.value = true;
    final fetchAlbum = await _musicService.getAlbum(offset: _albumList.length.toString());
    _albumList.addAll(fetchAlbum.results ?? <AlbumData>[]);
    _isFetchNextData.value = false;
  }
}