class MusicModel {
  Headers? headers;
  List<Results>? results;

  MusicModel({this.headers, this.results});

  MusicModel.fromJson(Map<String, dynamic> json) {
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headers != null) {
      data['headers'] = headers!.toJson();
    }
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Headers {
  String? status;
  int? code;
  String? errorMessage;
  String? warnings;
  int? resultsCount;
  String? next;

  Headers({
    this.status,
    this.code,
    this.errorMessage,
    this.warnings,
    this.resultsCount,
    this.next,
  });

  Headers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    errorMessage = json['error_message'];
    warnings = json['warnings'];
    resultsCount = json['results_count'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['error_message'] = errorMessage;
    data['warnings'] = warnings;
    data['results_count'] = resultsCount;
    data['next'] = next;
    return data;
  }
}

class Results {
  String? id;
  String? name;
  int? duration;
  String? artistId;
  String? artistName;
  String? artistIdstr;
  String? albumName;
  String? albumId;
  String? licenseCcurl;
  int? position;
  String? releasedate;
  String? albumImage;
  String? audio;
  String? audiodownload;
  String? prourl;
  String? shorturl;
  String? shareurl;
  bool? audiodownloadAllowed;
  String? image;

  Results({
    this.id,
    this.name,
    this.duration,
    this.artistId,
    this.artistName,
    this.artistIdstr,
    this.albumName,
    this.albumId,
    this.licenseCcurl,
    this.position,
    this.releasedate,
    this.albumImage,
    this.audio,
    this.audiodownload,
    this.prourl,
    this.shorturl,
    this.shareurl,
    this.audiodownloadAllowed,
    this.image,
  });

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    artistId = json['artist_id'];
    artistName = json['artist_name'];
    artistIdstr = json['artist_idstr'];
    albumName = json['album_name'];
    albumId = json['album_id'];
    licenseCcurl = json['license_ccurl'];
    position = json['position'];
    releasedate = json['releasedate'];
    albumImage = json['album_image'];
    audio = json['audio'];
    audiodownload = json['audiodownload'];
    prourl = json['prourl'];
    shorturl = json['shorturl'];
    shareurl = json['shareurl'];
    audiodownloadAllowed = json['audiodownload_allowed'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['artist_id'] = artistId;
    data['artist_name'] = artistName;
    data['artist_idstr'] = artistIdstr;
    data['album_name'] = albumName;
    data['album_id'] = albumId;
    data['license_ccurl'] = licenseCcurl;
    data['position'] = position;
    data['releasedate'] = releasedate;
    data['album_image'] = albumImage;
    data['audio'] = audio;
    data['audiodownload'] = audiodownload;
    data['prourl'] = prourl;
    data['shorturl'] = shorturl;
    data['shareurl'] = shareurl;
    data['audiodownload_allowed'] = audiodownloadAllowed;
    data['image'] = image;
    return data;
  }
}
