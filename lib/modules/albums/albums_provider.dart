import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lyrica/modules/albums/albums_model.dart';

class AlbumProvider with ChangeNotifier {
  AlbumsModel? _album;
  bool _isLoading = false;
  String _error = '';

  AlbumsModel? get album => _album;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAlbum(String albumId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/albums/$albumId'),
        headers: {
          'Authorization':
              'Bearer BQCXFPY6gK8wx5T8rWKHaFw-_sCXgvOIwKXzfW9QlG3hPj16mTgW0rxxiiRfhrhzvV-CKWCNWuSXEOz5JvIiO-_4ZPOSv4IfRjGvHCsOaqYdIY4q2zh-JKH9BHTcUQ-frsqnUgog9GHtT5PXsVlPxQfb1-HKcTt-ByYyi1hmodVZYxPa7BhCTPxNULFHW2tEuitsGfws3wS9bXmOYs0kC4Wmt7K3wqdBGTCIS6K20QkRIsSmMn0umz6k4taBaUXjUSfGxzMKjiePqJngl_tbp0s9k_LkzEjbWRY_u1Vw-y02aVHA0C-_FQ1pA1_f-9SJ',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _album = AlbumsModel.fromJson(jsonData);
        _error = '';
      } else {
        _error = 'Failed to load album: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching album: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
