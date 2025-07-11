import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyrica/modules/auth/instagram/constraint/instagram_constraint.dart';

class InstagramModel {
  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;
  String? error;

  void getAuthorizationCode(String url) {
    final uri = Uri.parse(url);

    if (uri.queryParameters['error'] != null) {
      error = uri.queryParameters['error_description'];
      debugPrint('Instagram Auth Error: $error');
      return;
    }

    authorizationCode = uri.queryParameters['code'];
    debugPrint('Authorization Code: $authorizationCode');
  }

  Future<bool> getTokenAndUserID() async {
    if (authorizationCode == null) return false;

    try {
      final response = await http.post(
        Uri.parse(InstagramConstant.tokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': InstagramConstant.clientID,
          'client_secret': InstagramConstant.appSecret,
          'grant_type': 'authorization_code',
          'redirect_uri': InstagramConstant.redirectUri,
          'code': authorizationCode!,
        },
      );

      debugPrint('Token Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        accessToken = data['access_token'];
        userID = data['user_id'].toString();
        return true;
      } else {
        final errorData = json.decode(response.body);
        error = errorData['error_message'] ?? 'Unknown error getting token';
        return false;
      }
    } catch (e) {
      error = 'Exception getting token: $e';
      return false;
    }
  }

  Future<bool> getUserProfile() async {
    if (accessToken == null || userID == null) return false;

    try {
      final response = await http.get(
        Uri.parse(
          '${InstagramConstant.graphUrl}/$userID?fields=id,username,account_type&access_token=$accessToken',
        ),
      );

      debugPrint('Profile Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        username = data['username'];
        return true;
      } else {
        final errorData = json.decode(response.body);
        error =
            errorData['error']['message'] ?? 'Unknown error getting profile';
        return false;
      }
    } catch (e) {
      error = 'Exception getting profile: $e';
      return false;
    }
  }
}
