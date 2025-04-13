import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:music_playlist_app/models/album.dart';
import 'package:music_playlist_app/models/album_track.dart';
import 'package:music_playlist_app/services/music/services.dart';

class PlaylistScreenController extends GetxController {
  final MusicService _musicService = Get.find();

  late final RxList<AlbumData> _albumList = RxList<AlbumData>();
  List<AlbumData> get fetchAlbum => _albumList;

  late final Rxn<AlbumTrackData> _albumDetail = Rxn<AlbumTrackData>();
  AlbumTrackData? get albumDetail => _albumDetail.value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _isFetchNextData = false.obs;
  bool get isFetchNextData => _isFetchNextData.value;

  final _isShowPlayer = false.obs;
  bool get isShowPlayer => _isShowPlayer.value;

  final _playingTrackId = "".obs;
  String get playingTrackId => _playingTrackId.value;

  final _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;

  String _playingAlbumId = "";

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

  Future playAlbum(String? id) async {
    if (id == null || id == "") {
      return ;
    }

    if (_playingAlbumId != id) {
      _playingAlbumId = id;
      final tracksData = await _musicService.getAlbumTrack(id);
      _albumDetail.value = tracksData.results?.first;
      _isShowPlayer.value = true;
    }
  }

  void stopMusic() {
    _isShowPlayer.value = false;
  }

  String? getTrackUrl(String? trackId) {
    if (trackId == null) {
      return null;
    }

    _playingTrackId.value = trackId;
    return _albumDetail.value?.tracks?.firstWhereOrNull((element) => element.id == trackId,)?.audio;
  }

  void triggerPlayerState(bool state) {
    _isPlaying.value = state;
  }
}