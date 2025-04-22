import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lyrica/model/music_model.dart';

class ApiServices {
  final String? baseApiKey = dotenv.env['BASE_URL_API_KEY'];

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
}

final apiProvider = Provider((ref) => ApiServices());


//   final String baseUrl = 
    //  "https://api.jamendo.com/v3.0/tracks/?client_id=540fd4db";