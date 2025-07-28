import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabaseService {
  static late Db db;
  static late DbCollection favoriteCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(
        "mongodb+srv://admin:admin@lyricacluster.lbgxhsq.mongodb.net/?retryWrites=true&w=majority&appName=LyricaCluster",
        // mongodb+srv://admin:<db_password>@lyricacluster.lbgxhsq.mongodb.net/?retryWrites=true&w=majority&appName=LyricaCluster    // favoriteSongs  // lyricaDB
        // for MongoDB Shell - command to connect mongodb server
        // mongosh "mongodb+srv://lyricacluster.lbgxhsq.mongodb.net/" --apiVersion 1 --username admin
      );
      await db.open();
      favoriteCollection = db.collection("favoriteSongs");
      log("MongoDB Connected");
    } catch (e) {
      log("MongoDB Connection Error: $e");
    }
  }

  static Future<void> close() async {
    try {
      await db.close();
    } catch (e) {
      log("Error closing MongoDB: $e");
    }
  }

  static Future<void> addFavorite(
    Map<String, dynamic> song,
    String userId,
  ) async {
    if (song.isEmpty || userId.isEmpty) return;

    final songWithId = {...song, "_id": song["id"], "userId": userId};

    try {
      await favoriteCollection.insertOne(songWithId);
      log("Added favorite song for user $userId: ${song['name']}");
    } catch (e) {
      log("Add favorite error: $e");
    }
  }

  static Future<void> removeFavorite(String songId, String userId) async {
    try {
      await favoriteCollection.deleteOne({"_id": songId, "userId": userId});
      log("Removed song $songId from favorites of user $userId");
    } catch (e) {
      log("Remove favorite error: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
      final results =
          await favoriteCollection.find({"userId": userId}).toList();
      return results.map((doc) {
        doc.remove("_id");
        return doc;
      }).toList();
    } catch (e) {
      log("Get favorites error: $e");
      return [];
    }
  }

  static Future<bool> isFavorite(String songId, String userId) async {
    try {
      final result = await favoriteCollection.findOne({
        "_id": songId,
        "userId": userId,
      });
      return result != null;
    } catch (e) {
      log("Check favorite error: $e");
      return false;
    }
  }
}
