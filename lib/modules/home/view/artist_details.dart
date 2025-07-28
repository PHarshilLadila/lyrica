// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtistDetails extends ConsumerStatefulWidget {
  final String? id;
  final String? name;
  final String? date;
  final String? website;
  final String? short;
  final String? share;
  final String? image;

  const ArtistDetails({
    super.key,
    this.name,
    this.date,
    this.website,
    this.short,
    this.share,
    this.image,
    this.id,
  });

  @override
  ConsumerState<ArtistDetails> createState() => _ArtistDetailsState();
}

class _ArtistDetailsState extends ConsumerState<ArtistDetails> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double showoffset = 5.0;

      if (scrollController.offset > showoffset) {
        if (!showbtn) {
          setState(() {
            showbtn = true;
          });
        }
      } else {
        if (showbtn) {
          setState(() {
            showbtn = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artistMusicDataProviderSync = ref.watch(
      artistMusicDataProvider(widget.id ?? ""),
    );

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: AppText(
            text: widget.name ?? "",
            fontSize: 20.sp,
            textColor: Color(AppColors.lightText),
            fontWeight: FontWeight.w500,
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.image ?? AppString.defaultImageLogo,
                      // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                    text: widget.name ?? "Unknown Artist",
                    fontSize: 24.sp,
                    textColor: Color(AppColors.lightText),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                    text: "From : ${widget.date ?? "N/A"}",
                    fontSize: 16.sp,
                    textColor: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(153, 167, 251, 255).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AppText(
                                text: "Website Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(
                                    ClipboardData(text: widget.website ?? ""),
                                  ).then((value) {
                                    showAppSnackBar(
                                      context,
                                      AppLocalizations.of(
                                        context,
                                      )!.webLinkCopied,
                                      Color(AppColors.successColor),
                                    );
                                  });
                                },
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                    widget.website ?? "",
                                  );
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.website ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  text:
                                      widget.website ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: AppText(
                                text: "Short Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(
                                    ClipboardData(text: widget.short ?? ""),
                                  ).then((value) {
                                    showAppSnackBar(
                                      context,
                                      AppLocalizations.of(
                                        context,
                                      )!.shortLinkCopied,
                                      Color(AppColors.successColor),
                                    );
                                  });
                                },
                                onTap: () async {
                                  final Uri url = Uri.parse(widget.short ?? "");
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.short ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  text:
                                      widget.short ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: AppText(
                                text: "Share Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(
                                    ClipboardData(text: widget.share ?? ""),
                                  ).then((value) {
                                    showAppSnackBar(
                                      context,
                                      AppLocalizations.of(
                                        context,
                                      )!.shareLinkCopied,
                                      Color(AppColors.successColor),
                                    );
                                  });
                                },
                                onTap: () async {
                                  final Uri url = Uri.parse(widget.share ?? "");
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.share ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  text:
                                      widget.share ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Artist Songs Section
                AppText(
                  text: "${widget.name}'s Songs",
                  fontSize: 20.sp,
                  textColor: Color(AppColors.lightText),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),

                artistMusicDataProviderSync.when(
                  data: (artistDetails) {
                    if (artistDetails.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 18.h),
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.logoWithoutBG,
                                height: 80.h,
                                width: 80.w,
                              ),
                              SizedBox(height: 8.h),
                              AppText(
                                text: "No songs available for this artist.",
                                fontSize: 16.sp,
                                textColor: Colors.white54,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 8.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: artistDetails.length,
                        itemBuilder: (context, index) {
                          final song = artistDetails[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 8.h,
                              left: 8.w,
                              right: 8.w,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      song.image ?? AppString.defaultImageLogo,
                                      width: 50.w,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),

                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: song.name ?? "Unknown Song",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          textColor: Color(AppColors.lightText),
                                        ),
                                        // SizedBox(height: 2.h),
                                        AppText(
                                          text: song.albumName ?? "N/A",
                                          fontSize: 12.sp,
                                          textColor: Colors.white54,
                                        ),
                                        SizedBox(height: 12.h),

                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //     gradient: LinearGradient(
                                        //       colors: [
                                        //         Color(
                                        //           AppColors.primaryColor,
                                        //         ).withOpacity(0.3),
                                        //         Color(
                                        //           AppColors.blueThird,
                                        //         ).withOpacity(0.3),
                                        //       ],
                                        //       begin: Alignment.centerLeft,
                                        //       end: Alignment.centerRight,
                                        //     ),
                                        //     borderRadius: BorderRadius.circular(
                                        //       30,
                                        //     ),
                                        //     boxShadow: [
                                        //       BoxShadow(
                                        //         color: Color(
                                        //           AppColors.primaryColor,
                                        //         ).withOpacity(0.18),
                                        //         blurRadius: 8,
                                        //         offset: Offset(0, 4),
                                        //       ),
                                        //     ],
                                        //   ),
                                        //   padding: EdgeInsets.symmetric(
                                        //     horizontal: 8.w,
                                        //     vertical: 6.h,
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       FaIcon(
                                        //         FontAwesomeIcons.arrowDown,
                                        //         color: Color(
                                        //           AppColors.lightText,
                                        //         ),
                                        //         size: 13.sp,
                                        //       ),
                                        //       SizedBox(width: 6),
                                        //       AppText(
                                        //         text: "Download",
                                        //         fontSize: 10.sp,
                                        //         fontWeight: FontWeight.bold,
                                        //         textColor: Color(
                                        //           AppColors.lightText,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: FaIcon(
                                              context
                                                      .watch<FavoriteProvider>()
                                                      .isFavorite(song.id ?? "")
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                            ),
                                            iconSize: 20.sp,
                                            color:
                                                context
                                                        .watch<
                                                          FavoriteProvider
                                                        >()
                                                        .isFavorite(
                                                          song.id ?? "",
                                                        )
                                                    ? Color(AppColors.blueLight)
                                                    : Color(
                                                      AppColors.primaryColor,
                                                    ),

                                            onPressed: () async {
                                              final SharedPreferences
                                              preferences =
                                                  await SharedPreferences.getInstance();
                                              final String? userId = preferences
                                                  .getString("userUID");
                                              final songData = {
                                                "userId": userId,

                                                "id": song.id,
                                                "name": song.name,
                                                "artistName": song.artistName,
                                                "image": song.image,
                                                "audio": song.audio,
                                                "audioDuration": song.duration,
                                                "albumImage": song.albumImage,
                                                "albumName": song.albumName,
                                                "position": song.position,
                                              };
                                              context
                                                  .read<FavoriteProvider>()
                                                  .toggleFavorite(songData);
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint(
                                                "Song tapped: ${song.name}",
                                              );
                                              myPushNavigator(
                                                context,
                                                MusicPlayer(
                                                  songList: artistDetails,
                                                  initialIndex: index,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 35.w,
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(
                                                      AppColors.primaryColor,
                                                    ),
                                                    Color(AppColors.blueLight),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(
                                                      AppColors.primaryColor,
                                                    ).withOpacity(0.4),
                                                    blurRadius: 14,
                                                    spreadRadius: 0,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.play,
                                                  color: Colors.white,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return const Center(child: Text("Something went wrong!"));
                  },
                  loading: () {
                    return Center(child: appLoader());
                  },
                ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedOpacity(
          opacity: showbtn ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 23, 106, 109),
                    Color.fromARGB(255, 29, 178, 183),
                    Color.fromARGB(255, 29, 178, 183),
                    Color.fromARGB(255, 23, 106, 109),
                  ],
                ),
                border: Border.all(color: Colors.white54, width: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.arrowUpLong,
                    color: Color(AppColors.whiteBackground),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
