class ArtistModel {
  Headers? headers;
  List<ArtistResults>? results;

  ArtistModel({this.headers, this.results});

  ArtistModel.fromJson(Map<String, dynamic> json) {
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    if (json['results'] != null) {
      results = <ArtistResults>[];
      json['results'].forEach((v) {
        results!.add(ArtistResults.fromJson(v));
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

class ArtistResults {
  String? id;
  String? name;
  String? website;
  String? joindate;
  String? image;
  String? shorturl;
  String? shareurl;

  ArtistResults({
    this.id,
    this.name,
    this.website,
    this.joindate,
    this.image,
    this.shorturl,
    this.shareurl,
  });

  ArtistResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    website = json['website'];
    joindate = json['joindate'];
    image = json['image'];
    shorturl = json['shorturl'];
    shareurl = json['shareurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['website'] = website;
    data['joindate'] = joindate;
    data['image'] = image;
    data['shorturl'] = shorturl;
    data['shareurl'] = shareurl;
    return data;
  }
}
