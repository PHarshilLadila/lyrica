// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';

// OnAudioQuery onAudioQuery = OnAudioQuery();
// Future<void> accessStorage() async =>
//     await Permission.storage.status.isGranted.then((granted) async {
//       if (granted == false) {
//         PermissionStatus permissionStatus = await Permission.storage.request();
//         if (permissionStatus == PermissionStatus.permanentlyDenied) {
//           await openAppSettings();
//         }
//       }
//     });

// Future<Uint8List?> art({required int id}) async {
//   return await onAudioQuery.queryArtwork(id, ArtworkType.AUDIO, quality: 100);
// }

// Future<Uint8List?> toImage({required Uri uri}) async {
//   return base64Decode(uri.data!.toString().split(",").last);
// }

// class FetchSongs {
//   static Future<List<MediaItem>> execute() async {
//     List<MediaItem> items = [];

//     await accessStorage().then((_) async {
//       List<SongModel> songs = await onAudioQuery.querySongs();

//       for (SongModel song in songs) {
//         if (song.isMusic == true) {
//           Uint8List? unit8List = await art(id: song.id);
//           List<int> bytes = [];
//           if (unit8List != null) {
//             bytes = unit8List.toList();
//           }

//           items.add(
//             MediaItem(
//               id: song.uri!,
//               title: song.title,
//               artist: song.artist,
//               duration: Duration(milliseconds: song.duration!),
//               artUri: unit8List == null ? null : Uri.dataFromBytes(bytes),
//             ),
//           );
//         }
//       }
//     });
//     return items;
//   }
// }
