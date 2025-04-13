import 'dart:convert';

Album albumFromJson(String str) => Album.fromJson(json.decode(str));

class Album {
  final Headers? headers;
  final List<AlbumData>? results;

  Album({
    this.headers,
    this.results,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    headers: json["headers"] == null ? null : Headers.fromJson(json["headers"]),
    results: json["results"] == null ? [] : List<AlbumData>.from(json["results"]!.map((x) => AlbumData.fromJson(x))),
  );
}

class Headers {
  final String? status;
  final int? code;
  final String? errorMessage;
  final String? warnings;
  final int? resultsCount;
  final String? next;

  Headers({
    this.status,
    this.code,
    this.errorMessage,
    this.warnings,
    this.resultsCount,
    this.next,
  });

  factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    status: json["status"],
    code: json["code"],
    errorMessage: json["error_message"],
    warnings: json["warnings"],
    resultsCount: json["results_count"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "error_message": errorMessage,
    "warnings": warnings,
    "results_count": resultsCount,
    "next": next,
  };
}

class AlbumData {
  final String? id;
  final String? name;
  final DateTime? releaseDate;
  final String? artistId;
  final String? artistName;
  final String? image;
  final String? zip;
  final String? shortUrl;
  final String? shareUrl;
  final bool? zipAllowed;

  AlbumData({
    this.id,
    this.name,
    this.releaseDate,
    this.artistId,
    this.artistName,
    this.image,
    this.zip,
    this.shortUrl,
    this.shareUrl,
    this.zipAllowed,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) => AlbumData(
    id: json["id"],
    name: json["name"],
    releaseDate: json["releasedate"] == null ? null : DateTime.parse(json["releasedate"]),
    artistId: json["artist_id"],
    artistName: json["artist_name"],
    image: json["image"],
    zip: json["zip"],
    shortUrl: json["shorturl"],
    shareUrl: json["shareurl"],
    zipAllowed: json["zip_allowed"],
  );
}
