class Track {
  final String name;
  final String artistName;
  final String albumImage;
  final String audio;

  Track({
    required this.name,
    required this.artistName,
    required this.albumImage,
    required this.audio,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'] ?? '',
      artistName: json['artist_name'] ?? '',
      albumImage: json['album_image'] ?? '',
      audio: json['audio'] ?? '',
    );
  }
}
