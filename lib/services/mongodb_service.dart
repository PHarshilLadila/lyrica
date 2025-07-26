import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabaseService {
  static late Db db;
  static DbCollection? favoriteCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(
        "mongodb+srv://admin:admin@lyricacluster.lbgxhsq.mongodb.net/?retryWrites=true&w=majority&appName=LyricaCluster",

        // for MongoDB Shell - command to connect mongodb server
        // mongosh "mongodb+srv://lyricacluster.lbgxhsq.mongodb.net/" --apiVersion 1 --username admin
      );
      await db.open();
      favoriteCollection = db.collection("favoriteSongs");
      log("MongoDB Connected");

      inspect(db);
    } catch (e) {
      log(e.toString());
      log("MongoDB Connection Error: $e");
    }
  }

  static Future<void> close() async {
    try {
      await db.close();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> addFavorite(Map<String, dynamic> song) async {
    if (favoriteCollection == null) return;

    final songWithId = {...song, "_id": song["id"]};
    await favoriteCollection!.insertOne(songWithId);
  }

  static Future<void> removeFavorite(String id) async {
    if (favoriteCollection == null) return;

    await favoriteCollection!.deleteOne({"id": id});
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    if (favoriteCollection == null) return [];

    final results = await favoriteCollection!.find().toList();
    return results.map((doc) {
      doc.remove("_id");
      return doc;
    }).toList();
  }

  static Future<bool> isFavorite(String id) async {
    if (favoriteCollection == null) return false;

    final result = await favoriteCollection!.findOne({"id": id});
    return result != null;
  }
}

// mongodb+srv://admin:<db_password>@lyricacluster.lbgxhsq.mongodb.net/?retryWrites=true&w=majority&appName=LyricaCluster    // favoriteSongs  // lyricaDB
