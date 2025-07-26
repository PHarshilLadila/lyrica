class AlbumsModel {
  String albumType;
  int totalTracks;
  List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  DateTime releaseDate;
  String releaseDatePrecision;
  String type;
  String uri;
  List<Artist> artists;
  Tracks tracks;
  List<Copyright> copyrights;
  ExternalIds externalIds;
  List<dynamic> genres;
  String label;
  int popularity;

  AlbumsModel({
    required this.albumType,
    required this.totalTracks,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.type,
    required this.uri,
    required this.artists,
    required this.tracks,
    required this.copyrights,
    required this.externalIds,
    required this.genres,
    required this.label,
    required this.popularity,
  });

  factory AlbumsModel.fromJson(Map<String, dynamic> json) => AlbumsModel(
    albumType: json["album_type"],
    totalTracks: json["total_tracks"],
    availableMarkets: List<String>.from(
      json["available_markets"].map((x) => x),
    ),
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    name: json["name"],
    releaseDate: DateTime.parse(json["release_date"]),
    releaseDatePrecision: json["release_date_precision"],
    type: json["type"],
    uri: json["uri"],
    artists: List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
    tracks: Tracks.fromJson(json["tracks"]),
    copyrights: List<Copyright>.from(
      json["copyrights"].map((x) => Copyright.fromJson(x)),
    ),
    externalIds: ExternalIds.fromJson(json["external_ids"]),
    genres: List<dynamic>.from(json["genres"].map((x) => x)),
    label: json["label"],
    popularity: json["popularity"],
  );

  // ... rest of your existing model code (copyWith methods, etc.)
}

class Artist {
  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  String type;
  String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    name: json["name"],
    type: json["type"],
    uri: json["uri"],
  );
}

class ExternalUrls {
  String spotify;

  ExternalUrls({required this.spotify});

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      ExternalUrls(spotify: json["spotify"]);
}

class Copyright {
  String text;
  String type;

  Copyright({required this.text, required this.type});

  factory Copyright.fromJson(Map<String, dynamic> json) =>
      Copyright(text: json["text"], type: json["type"]);
}

class ExternalIds {
  String upc;

  ExternalIds({required this.upc});

  factory ExternalIds.fromJson(Map<String, dynamic> json) =>
      ExternalIds(upc: json["upc"]);
}

class Image {
  String url;
  int height;
  int width;

  Image({required this.url, required this.height, required this.width});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(url: json["url"], height: json["height"], width: json["width"]);
}

class Tracks {
  String href;
  int limit;
  dynamic next;
  int offset;
  dynamic previous;
  int total;
  List<Item> items;

  Tracks({
    required this.href,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
    required this.items,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) => Tracks(
    href: json["href"],
    limit: json["limit"],
    next: json["next"],
    offset: json["offset"],
    previous: json["previous"],
    total: json["total"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  // ... rest of your existing model code
}

class Item {
  List<Artist> artists;
  List<String> availableMarkets;
  int discNumber;
  int durationMs;
  bool explicit;
  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  dynamic previewUrl;
  int trackNumber;
  String type;
  String uri;
  bool isLocal;

  Item({
    required this.artists,
    required this.availableMarkets,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
    required this.isLocal,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    artists: List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
    availableMarkets: List<String>.from(
      json["available_markets"].map((x) => x),
    ),
    discNumber: json["disc_number"],
    durationMs: json["duration_ms"],
    explicit: json["explicit"],
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    name: json["name"],
    previewUrl: json["preview_url"],
    trackNumber: json["track_number"],
    type: json["type"],
    uri: json["uri"],
    isLocal: json["is_local"],
  );

  // ... rest of your existing model code
}
