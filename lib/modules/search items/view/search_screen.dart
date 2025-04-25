// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool isSearched = false;
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(gradient: backgroundGradient()),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(221, 39, 39, 39),
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
            title: Text(
              "Search & Explore",
              style: GoogleFonts.poppins(
                color: Color(AppColors.lightText),
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
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
                    Color.fromARGB(255, 67, 255, 246),
                    Color(AppColors.secondaryColor),
                    Color.fromARGB(255, 67, 255, 246),
                    Color(AppColors.primaryColor),
                  ],
                ),
              ),

              dividerColor: Colors.pinkAccent,
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
                    textColor: Color(AppColors.lightText),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.search, color: Color(AppColors.lightText)),
                  child: AppText(
                    textName: "Explore Music",
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
                                  Positioned(
                                    right: -30,
                                    bottom: -30,
                                    child: Image.asset(
                                      "${categorieBox[index]['image']}",
                                      width: 120.w,
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      AppText(
                        textColor: Color(AppColors.lightText),
                        textName: "Find Songs",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 15.h),
                      AppCustomTextFormField(
                        keyboradType: TextInputType.text,
                        borderColor: Color(AppColors.primaryColor),
                        enabledColor: Color(AppColors.secondaryColor),
                        fillColor: Colors.white10,
                        focusedColor: Color(AppColors.primaryColor),
                        disabledColor: Color(AppColors.whiteBackground),
                        hintText: "Search Music",
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
                      SizedBox(height: 10.h),
                      isSearched
                          ? SizedBox(
                            height: 500.h,
                            child: resultsAsync.when(
                              data:
                                  (tracks) => ListView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: tracks.length,
                                    itemBuilder: (context, index) {
                                      final track = tracks[index];
                                      return Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              track.albumImage ?? "",
                                              width: 50,
                                              errorBuilder:
                                                  (_, __, ___) => const Icon(
                                                    Icons.music_note,
                                                  ),
                                            ),
                                          ),
                                          title: Text(track.name ?? ""),
                                          subtitle: Text(
                                            track.artistName ?? "",
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.play_arrow),
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
                                        ),
                                      );
                                    },
                                  ),
                              loading: () => Center(child: appLoader()),
                              error: (e, _) => Center(child: Text('Error: $e')),
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
                                SizedBox(height: 8.h),
                                AppText(
                                  textName: "Find Your Fevorite Music..🤩",
                                  textColor: Color(AppColors.primaryColor),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
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
