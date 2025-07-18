// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/list_helper.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/common/widget/app_text_form_field.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:lyrica/modules/music%20track/view/music_track_list.dart';
import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final bool fromPlaylist;
  const SearchScreen(this.fromPlaylist, {super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool isSearched = false;
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final playlist = ref.watch(playlistProvider);

    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(gradient: backgroundGradient()),
        child: Scaffold(
          floatingActionButton:
              widget.fromPlaylist
                  ? ScaleTransition(
                    scale: AlwaysStoppedAnimation(1),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Color(AppColors.primaryColor),
                      foregroundColor: Color(AppColors.whiteBackground),
                      elevation: 6,
                      hoverElevation: 12,
                      focusElevation: 8,
                      highlightElevation: 12,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Color(
                            AppColors.whiteBackground,
                          ).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.playlist_add_check_rounded,
                          size: 24.sp,
                        ),
                      ),
                      label: AppText(
                        textName: "Back to Playlist",
                        fontSize: 16.sp,
                        textColor: Color(AppColors.whiteBackground),
                        fontWeight: FontWeight.w600,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  : SizedBox.shrink(),
          backgroundColor: const Color.fromARGB(197, 0, 43, 53),
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AppImages.logoWithoutBG),
              ),
            ),
            elevation: 0,
            toolbarHeight: 90,
            backgroundColor: Colors.transparent,
            title: AppText(
              textName: "Search & Explore",
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              textColor: Color(AppColors.lightText),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GoogleLoginScreen(),
                    ),
                  );
                  showSnackBar(
                    context,
                    "Sign out Successfully..!",
                    Color(AppColors.successColor),
                  );
                },
                icon: Image.asset(AppImages.barIcon, width: 25.w),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(AppImages.notificationIcon, width: 25.w),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(AppImages.settingIcon, width: 25.w),
              ),
            ],
            bottom: TabBar(
              indicatorAnimation: TabIndicatorAnimation.linear,
              mouseCursor: MouseCursor.defer,

              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(AppColors.primaryColor),
                    Color.fromARGB(255, 16, 217, 224),

                    Color(AppColors.secondaryColor),
                    Color.fromARGB(255, 16, 217, 224),

                    Color(AppColors.secondaryColor),
                    Color.fromARGB(255, 16, 217, 224),

                    Color(AppColors.primaryColor),
                  ],
                ),
              ),

              dividerColor: Color(AppColors.darkBlue),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color(AppColors.primaryColor),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.my_library_music,
                    color: Color(AppColors.lightText),
                  ),
                  child: AppText(
                    textName: "Categories",
                    fontWeight: FontWeight.w600,
                    textColor: Color(AppColors.lightText),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.search, color: Color(AppColors.lightText)),
                  child: AppText(
                    textName: "Explore Music",
                    fontWeight: FontWeight.w600,
                    textColor: Color(AppColors.lightText),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),

                      AppText(
                        textColor: Color(AppColors.lightText),
                        textName: "Your Top Genres",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 15.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: categorieBox.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.5,
                        ),
                        itemBuilder: (context, index) {
                          var mainColor = int.parse(
                            "${categorieBox[index]["color"]}",
                          );
                          return GestureDetector(
                            onTap: () {
                              // String selectedGenre = categorieBox[index]['pop'];
                              if (index == 0) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=rock&limit=200",
                                  ),
                                );
                              } else if (index == 1) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=pop&limit=200",
                                  ),
                                );
                              } else if (index == 2) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=jazz&limit=200",
                                  ),
                                );
                              } else if (index == 3) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=hiphop&limit=200",
                                  ),
                                );
                              } else if (index == 4) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=funk&limit=200",
                                  ),
                                );
                              } else if (index == 5) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=dance&limit=200",
                                  ),
                                );
                              } else if (index == 6) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=romantic&limit=200",
                                  ),
                                );
                              } else if (index == 7) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=lofi&limit=200",
                                  ),
                                );
                              } else if (index == 8) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=disco&limit=200",
                                  ),
                                );
                              } else if (index == 9) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=sad&limit=200",
                                  ),
                                );
                              } else if (index == 10) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=gospel&limit=200",
                                  ),
                                );
                              } else if (index == 11) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=love&limit=200",
                                  ),
                                );
                              } else if (index == 12) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=electronic&limit=200",
                                  ),
                                );
                              } else if (index == 13) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=latin&limit=200",
                                  ),
                                );
                              } else if (index == 14) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=classical&limit=200",
                                  ),
                                );
                              } else if (index == 15) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=ambient&limit=200",
                                  ),
                                );
                              } else if (index == 16) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=metal&limit=200",
                                  ),
                                );
                              } else if (index == 17) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=acoustic&limit=200",
                                  ),
                                );
                              } else if (index == 18) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=reggae&limit=200",
                                  ),
                                );
                              } else if (index == 19) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=techno&limit=200",
                                  ),
                                );
                              } else if (index == 20) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=dubstep&limit=200",
                                  ),
                                );
                              } else if (index == 21) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=chillout&limit=200",
                                  ),
                                );
                              } else if (index == 22) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre:
                                        "format=json&tags=instrumental&limit=200",
                                  ),
                                );
                              } else if (index == 23) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=indie&limit=200",
                                  ),
                                );
                              } else if (index == 24) {
                                myPushNavigator(
                                  context,
                                  MusicTrackList(
                                    "${categorieBox[index]['name']}",
                                    musicType: -1,
                                    genre: "format=json&tags=world&limit=200",
                                  ),
                                );
                              }

                              debugPrint('$index');
                            },
                            child: Container(
                              height: 30.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: Color(mainColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -30,
                                    bottom: -30,
                                    child: Image.asset(
                                      "${categorieBox[index]['image']}",
                                      width: 120.w,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      top: 15,
                                    ),
                                    child: AppText(
                                      textName:
                                          "${categorieBox[index]['name']}",
                                      fontSize: 20.sp,
                                      textColor: Color(AppColors.lightText),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SingleChildScrollView(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height: 10.h),
              //         AppText(
              //           textColor: Color(AppColors.lightText),
              //           textName: "Find Songs",
              //           fontSize: 20.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //         SizedBox(height: 15.h),
              //         AppCustomTextFormField(
              //           keyboradType: TextInputType.text,
              //           borderColor: Color(AppColors.primaryColor),
              //           enabledColor: Color(AppColors.secondaryColor),
              //           fillColor: Colors.white10,
              //           focusedColor: Color(AppColors.primaryColor),
              //           disabledColor: Color(AppColors.whiteBackground),
              //           hintText: "Search Music",
              //           maxline: 1,
              //           hintcolors: Color(AppColors.whiteBackground),
              //           prefixIcon: Padding(
              //             padding: EdgeInsets.only(left: 10.w, top: 8.h),
              //             child: FaIcon(
              //               FontAwesomeIcons.search,
              //               color: Color(AppColors.blueExtraLight),
              //             ),
              //           ),
              //           obscureText: false,
              //           onChanged: (val) {
              //             ref.read(searchQueryProvider.notifier).state = val;
              //             isSearched = true;
              //           },
              //         ),
              //         SizedBox(height: 10.h),
              //         isSearched
              //             ? SizedBox(
              //               height: 500.h,
              //               child: resultsAsync.when(
              //                 data:
              //                     (tracks) => ListView.builder(
              //                       physics: ScrollPhysics(),
              //                       itemCount: tracks.length,
              //                       itemBuilder: (context, index) {
              //                         final track = tracks[index];
              //                         return Card(
              //                           color: Colors.white,
              //                           child: ListTile(
              //                             leading: ClipRRect(
              //                               borderRadius: BorderRadius.circular(
              //                                 12,
              //                               ),
              //                               child: Image.network(
              //                                 track.albumImage ?? "",
              //                                 width: 50,
              //                                 errorBuilder:
              //                                     (_, __, ___) => const Icon(
              //                                       Icons.music_note,
              //                                     ),
              //                               ),
              //                             ),
              //                             title: AppText(
              //                               textName: track.name ?? "",
              //                             ),
              //                             subtitle: AppText(
              //                               textName: track.artistName ?? "",
              //                             ),
              //                             trailing: SizedBox(
              //                               width: 100.w,
              //                               child: Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.end,
              //                                 children: [
              //                                   IconButton(
              //                                     icon: Icon(
              //                                       CupertinoIcons.add_circled,
              //                                       color: Colors.blueGrey,
              //                                     ),
              //                                     onPressed: () {},
              //                                   ),
              //                                   IconButton(
              //                                     icon: FaIcon(
              //                                       FontAwesomeIcons.play,
              //                                       color: Color(
              //                                         AppColors.primaryColor,
              //                                       ),
              //                                       size: 18.sp,
              //                                     ),
              //                                     onPressed: () {
              //                                       myPushNavigator(
              //                                         context,
              //                                         MusicPlayer(
              //                                           songList: tracks,
              //                                           initialIndex: index,
              //                                         ),
              //                                       );
              //                                     },
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         );
              //                       },
              //                     ),
              //                 loading: () => Center(child: appLoader()),
              //                 error:
              //                     (e, _) => Center(
              //                       child: AppText(textName: 'Error: $e'),
              //                     ),
              //               ),
              //             )
              //             : Center(
              //               child: Column(
              //                 children: [
              //                   SizedBox(height: 160.h),

              //                   Image.asset(
              //                     AppImages.logoWithoutBG,
              //                     height: 70.h,
              //                   ),
              //                   SizedBox(height: 8.h),
              //                   AppText(
              //                     textName: "Find Your Fevorite Music..🤩",
              //                     textColor: Color(AppColors.primaryColor),
              //                     fontSize: 14.sp,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //       ],
              //     ),
              //   ),
              // ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCustomTextFormField(
                        keyboradType: TextInputType.text,
                        borderColor: Color(AppColors.primaryColor),
                        enabledColor: Color(AppColors.secondaryColor),
                        fillColor: Colors.white10,
                        focusedColor: Color(AppColors.primaryColor),
                        disabledColor: Color(AppColors.whiteBackground),
                        hintText: "Search for songs...",
                        maxline: 1,
                        hintcolors: Color(AppColors.whiteBackground),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 8.h),
                          child: FaIcon(
                            FontAwesomeIcons.search,
                            color: Color(AppColors.blueExtraLight),
                          ),
                        ),
                        obscureText: false,
                        onChanged: (val) {
                          ref.read(searchQueryProvider.notifier).state = val;
                          isSearched = true;
                        },
                      ),
                      SizedBox(height: 20.h),
                      isSearched
                          ? resultsAsync.when(
                            data:
                                (tracks) =>
                                    tracks.isEmpty
                                        ? Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 100.h),
                                              Icon(
                                                Icons.search_off,
                                                size: 50.sp,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 16.h),
                                              AppText(
                                                textName: "No results found",
                                                fontSize: 16.sp,
                                                textColor: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: tracks.length,
                                          itemBuilder: (context, index) {
                                            final track = tracks[index];
                                            final isInPlaylist = playlist.any(
                                              (song) => song.id == track.id,
                                            );

                                            return Card(
                                              margin: EdgeInsets.only(
                                                bottom: 12.h,
                                              ),
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              child: ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  child: Image.network(
                                                    track.albumImage ?? "",
                                                    width: 50.w,
                                                    height: 50.h,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) => Icon(
                                                          Icons.music_note,
                                                          size: 30.sp,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                                title: AppText(
                                                  textName:
                                                      track.name ?? "Unknown",
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  textColor: Color(
                                                    AppColors.whiteBackground,
                                                  ),
                                                ),
                                                subtitle: AppText(
                                                  textName:
                                                      track.artistName ??
                                                      "Unknown artist",
                                                  fontSize: 12.sp,
                                                  textColor: Color(
                                                    AppColors.whiteBackground,
                                                  ).withOpacity(0.7),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    widget.fromPlaylist
                                                        ? IconButton(
                                                          icon: Icon(
                                                            isInPlaylist
                                                                ? Icons
                                                                    .check_circle
                                                                : CupertinoIcons
                                                                    .add_circled,
                                                            color:
                                                                isInPlaylist
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .blue,
                                                            size: 24.sp,
                                                          ),
                                                          onPressed: () {
                                                            if (isInPlaylist) {
                                                              showSnackBar(
                                                                context,
                                                                "${track.name} is already in playlist",
                                                                Colors.orange,
                                                              );
                                                            } else {
                                                              ref
                                                                  .read(
                                                                    playlistProvider
                                                                        .notifier,
                                                                  )
                                                                  .addSong(
                                                                    track,
                                                                  );
                                                              showSnackBar(
                                                                context,
                                                                "${track.name} added to playlist",
                                                                Color(
                                                                  AppColors
                                                                      .successColor,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        )
                                                        : SizedBox.shrink(),
                                                    IconButton(
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.play,
                                                        color: Color(
                                                          AppColors
                                                              .primaryColor,
                                                        ),
                                                        size: 18.sp,
                                                      ),
                                                      onPressed: () {
                                                        myPushNavigator(
                                                          context,
                                                          MusicPlayer(
                                                            songList: tracks,
                                                            initialIndex: index,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            loading: () => Center(child: appLoader()),
                            error:
                                (e, _) => Center(
                                  child: AppText(
                                    textName: 'Error: ${e.toString()}',
                                    textColor: Colors.red,
                                  ),
                                ),
                          )
                          : Center(
                            child: Column(
                              children: [
                                SizedBox(height: 160.h),
                                Image.asset(
                                  AppImages.logoWithoutBG,
                                  height: 70.h,
                                ),
                                SizedBox(height: 16.h),
                                AppText(
                                  textName: "Search for your favorite music",
                                  textColor: Color(AppColors.primaryColor),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 8.h),
                                AppText(
                                  textName: "Add songs to your playlist",
                                  textColor: Color(
                                    AppColors.whiteBackground,
                                  ).withOpacity(0.7),
                                  fontSize: 14.sp,
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
