import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lyrica/model/artist_model.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/model/track_model.dart';

class ApiServices {
  final String? baseApiKey = dotenv.env['BASE_URL_API_KEY'];
  final String? artistApi = dotenv.env['ARTIST_API_KEY'];
  final String? trackApi = dotenv.env['TRACK_API_KEY'];
  final String? hindiSongApi = dotenv.env['HINDI_SONG_API'];

  Future<List<Results>> getMusicList() async {
    try {
      final response = await http.get(
        Uri.parse("$baseApiKey&format=json&limit=150"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final music = MusicModel.fromJson(jsonData);
        return music.results ?? [];
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      throw Exception("Failed to load music: $e");
    }
  }

  Future<List<Results>> getMusicByGenre(String tag) async {
    try {
      final response = await http.get(
        Uri.parse("$baseApiKey&format=json&tags=$tag"),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final music = MusicModel.fromJson(jsonData);
        return music.results ?? [];
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ArtistResults>> getArtistList() async {
    try {
      final response = await http.get(Uri.parse("$artistApi"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final music = ArtistModel.fromJson(jsonData);
        return music.results ?? [];
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Results>> getArtistWiseSong(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseApiKey&format=json&limit=200&artist_id=$id"),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final music = MusicModel.fromJson(jsonData);
        return music.results ?? [];
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Track>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse('$trackApi&format=json&limit=25&namesearch=$query'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['results'] as List)
          .map((e) => Track.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }
  Future<List<Results>> getHindiSongsList() async {
    try {
      final response = await http.get(Uri.parse("$hindiSongApi"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final music = MusicModel.fromJson(jsonData);
        return music.results ?? [];
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final apiProvider = Provider((ref) => ApiServices());
