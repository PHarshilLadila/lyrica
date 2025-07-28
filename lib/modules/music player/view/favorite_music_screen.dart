// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FavoriteMusicScreen extends StatefulWidget {
  const FavoriteMusicScreen({super.key});

  @override
  State<FavoriteMusicScreen> createState() => _FavoriteMusicScreenState();
}

class _FavoriteMusicScreenState extends State<FavoriteMusicScreen> {
  @override
  void initState() {
    context.read<FavoriteProvider>().fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteProvider>().favorites;

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          title: AppText(
            text: "Favorite Songs",
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
            textColor: Color(AppColors.lightText),
          ),

          leading: AppBackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:
            favorites.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: Colors.teal.withOpacity(0.5),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No favorite songs yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tap the heart icon to add songs",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                )
                : ListView.builder(
                  padding: const EdgeInsets.only(top: 15, bottom: 80),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final song = favorites[index];
                    return Dismissible(
                      key: Key(song["id"].toString()),
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        context.read<FavoriteProvider>().toggleFavorite(song);
                        showAppSnackBar(
                          context,
                          'Removed ${song["name"]} from favorites',
                          Color(AppColors.successColor),
                        );
                      },
                      child: Card(
                            color: Color(
                              AppColors.whiteBackground,
                            ).withOpacity(0.2),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                final resultsList =
                                    favorites
                                        .map(
                                          (fav) => Results(
                                            id: fav["id"],
                                            name: fav["name"],
                                            artistName: fav["artistName"],
                                            image: fav["image"],
                                            audio: fav["audio"],
                                            duration: fav["audioDuration"],
                                            albumImage: fav["albumImage"],
                                            albumName: fav["albumName"],
                                            position: fav["position"],
                                          ),
                                        )
                                        .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MusicPlayer(
                                          songList: resultsList,
                                          initialIndex: index,
                                        ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'songImage_${song["id"]}',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            song["image"] != null
                                                ? Image.network(
                                                  song["image"],
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Container(
                                                        width: 60,
                                                        height: 60,
                                                        color: Colors.teal[100],
                                                        child: Icon(
                                                          Icons.music_note,
                                                          color:
                                                              Colors.teal[800],
                                                        ),
                                                      ),
                                                )
                                                : Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.teal[100],
                                                  child: Icon(
                                                    Icons.music_note,
                                                    color: Colors.teal[800],
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),

                                    // Song Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: song["name"] ?? "No Name",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            maxLines: 1,
                                            textColor: Color(
                                              AppColors.whiteBackground,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            song["artistName"] ??
                                                "Unknown Artist",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(
                                                AppColors.whiteBackground,
                                              ).withOpacity(0.8),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              if (song["albumImage"] != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    child: Image.network(
                                                      song["albumImage"],
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              Expanded(
                                                child: Text(
                                                  song["albumName"] ??
                                                      "Unknown Album",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(
                                                      AppColors.whiteBackground,
                                                    ).withOpacity(0.6),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          formatDuration(
                                            Duration(
                                              seconds:
                                                  song["audioDuration"] ?? 0,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(
                                              AppColors.whiteBackground,
                                            ).withOpacity(0.8),
                                          ),
                                        ),

                                        IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Color(
                                              AppColors.primaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<FavoriteProvider>()
                                                .toggleFavorite(song);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (30 * index).ms)
                          .slideX(
                            begin: 0.5,
                            duration: 100.ms,
                            curve: Curves.easeOut,
                          ),
                    );
                  },
                ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
