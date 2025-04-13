import 'package:flutter/material.dart';

abstract class AppConst {
  static String clientId = "99d99145";
  static String baseUrl = "https://api.jamendo.com/v3.0/";

  static String getAlbumUrl = "$baseUrl/albums/?client_id=$clientId&limit=20";
  static String getAlbumTrackUrl = "$baseUrl/albums/tracks/?client_id=$clientId"; // Pass id from getAlbum
}

abstract class UIConst {
  static SizedBox hDivider = const SizedBox(height: 16,);
  static SizedBox vDivider = const SizedBox(width: 16,);
}