import 'dart:convert';

AlbumTrack albumTrackFromJson(String str) => AlbumTrack.fromJson(json.decode(str));

class AlbumTrack {
  final Headers? headers;
  final List<Result>? results;

  AlbumTrack({
    this.headers,
    this.results,
  });

  factory AlbumTrack.fromJson(Map<String, dynamic> json) => AlbumTrack(
    headers: json["headers"] == null ? null : Headers.fromJson(json["headers"]),
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );
}

class Headers {
  final String? status;
  final int? code;
  final String? errorMessage;
  final String? warnings;
  final int? resultsCount;

  Headers({
    this.status,
    this.code,
    this.errorMessage,
    this.warnings,
    this.resultsCount,
  });

  factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    status: json["status"],
    code: json["code"],
    errorMessage: json["error_message"],
    warnings: json["warnings"],
    resultsCount: json["results_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "error_message": errorMessage,
    "warnings": warnings,
    "results_count": resultsCount,
  };
}

class Result {
  final String? id;
  final String? name;
  final DateTime? releaseDate;
  final String? artistId;
  final String? artistName;
  final String? image;
  final String? zip;
  final bool? zipAllowed;
  final List<Track>? tracks;

  Result({
    this.id,
    this.name,
    this.releaseDate,
    this.artistId,
    this.artistName,
    this.image,
    this.zip,
    this.zipAllowed,
    this.tracks,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    releaseDate: json["releasedate"] == null ? null : DateTime.parse(json["releasedate"]),
    artistId: json["artist_id"],
    artistName: json["artist_name"],
    image: json["image"],
    zip: json["zip"],
    zipAllowed: json["zip_allowed"],
    tracks: json["tracks"] == null ? [] : List<Track>.from(json["tracks"]!.map((x) => Track.fromJson(x))),
  );
}

class Track {
  final String? id;
  final String? position;
  final String? name;
  final String? duration;
  final String? licenseCcUrl;
  final String? audio;
  final String? audioDownload;
  final bool? audioDownloadAllowed;

  Track({
    this.id,
    this.position,
    this.name,
    this.duration,
    this.licenseCcUrl,
    this.audio,
    this.audioDownload,
    this.audioDownloadAllowed,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json["id"],
    position: json["position"],
    name: json["name"],
    duration: json["duration"],
    licenseCcUrl: json["license_ccurl"],
    audio: json["audio"],
    audioDownload: json["audiodownload"],
    audioDownloadAllowed: json["audiodownload_allowed"],
  );
}
