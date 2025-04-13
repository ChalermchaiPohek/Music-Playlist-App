import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:music_playlist_app/models/album.dart';
import 'package:music_playlist_app/models/album_track.dart';
import 'package:music_playlist_app/util/constants.dart';

class MusicService extends GetxService {

  Future<Album> getAlbum({String? offset}) async {
    try {
      String url = AppConst.getAlbumUrl;
      if (offset != null && offset != "") {
        url = "$url&offset=$offset";
      }

      final response = await http.get(Uri.parse(url));
      return Album.fromJson(jsonDecode(response.body));
    } catch (error, s) {
      if (kDebugMode) {
        print(s.toString());
      }
      rethrow;
    }
  }

  Future<AlbumTrack> getAlbumTrack(String albumId) async {
    final url = "${AppConst.getAlbumTrackUrl}&id=$albumId";
    try {
      final response = await http.get(Uri.parse(url));
      return AlbumTrack.fromJson(jsonDecode(response.body));
    } catch (error, s) {
      if (kDebugMode) {
        print(s.toString());
      }
      rethrow;
    }
  }

}