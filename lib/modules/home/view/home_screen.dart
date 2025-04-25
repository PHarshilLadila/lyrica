// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/list_helper.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/home/music/view/hindi_music_list.dart';
import 'package:lyrica/modules/home/view/artist_details.dart';
import 'package:lyrica/modules/home/view/artist_list.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:lyrica/modules/music%20track/view/music_track_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: unused_result
      ref.refresh(userModelProvider);
    });
  }

  Future<void> checkDeviceConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => "Internet Checking..");
    switch (result as ConnectivityResult) {
      case ConnectivityResult.mobile:
        setState(() {
          showSnackBar(
            context,
            "Connected to mobile network",
            Color(AppColors.darkYellow),
          );
        });
        break;

      case ConnectivityResult.bluetooth:
        setState(() {
          showSnackBar(
            context,
            "Connected to mobile bluetooth",
            Color(AppColors.errorColor),
          );
        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          showSnackBar(
            context,
            "Connected to mobile wifi",
            Color(AppColors.errorColor),
          );
        });
        break;
      case ConnectivityResult.ethernet:
        setState(() {
          showSnackBar(
            context,
            "Connected to mobile ethernet",
            Color(AppColors.errorColor),
          );
        });
        break;
      case ConnectivityResult.none:
        showSnackBar(
          context,
          "Please Connect with your Internet..!",
          Color(AppColors.successColor),
        );
        break;
      case ConnectivityResult.vpn:
        debugPrint("Connected to mobile vpn");
        break;
      case ConnectivityResult.other:
        setState(() {
          showSnackBar(
            context,
            "error in connectivity",
            Color(AppColors.errorColor),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final userModelAsync = ref.watch(userModelProvider);
    final artisAsync = ref.watch(artistDataProvider);
    final hindiSongAsync = ref.watch(hindiSongDataProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text("User not found"));

        return Container(
          decoration: BoxDecoration(gradient: backgroundGradient()),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(221, 39, 39, 39),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CircleAvatar(
                  backgroundColor: Color(AppColors.primaryColor),
                  child: userModelAsync.when(
                    data: (userModel) {
                      return Text(
                        userModel == null
                            ? user.displayName ??
                                userModel?.username[0] ??
                                "N12"
                            : userModel.username[0],
                        // user.displayName ?? "123",
                        style: GoogleFonts.poppins(
                          color: Color(AppColors.lightText),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    loading: () => SizedBox(),

                    error:
                        (e, _) => Text(
                          "Error loading user",
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ),
              ),
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: GoogleFonts.poppins(
                      color: Color(AppColors.lightText),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  userModelAsync.when(
                    data: (userModel) {
                      if (userModel == null) {
                        return Text(
                          user.displayName ?? "N/A",
                          style: GoogleFonts.poppins(
                            color: Color(AppColors.lightText),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        user.displayName ?? userModel.username,
                        style: GoogleFonts.poppins(
                          color: Color(AppColors.lightText),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    loading: () => SizedBox(),
                    error:
                        (e, _) => Text(
                          "Error loading user",
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
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
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hindi Version",
                            style: GoogleFonts.poppins(
                              color: Color(AppColors.lightText),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint("onTap() of view all hindi song");
                              myPushNavigator(context, HindiMusicList());
                            },
                            child: AppText(
                              fontSize: 14.sp,
                              textName: "View all",
                              fontWeight: FontWeight.w500,
                              textColor: Color(AppColors.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      hindiSongAsync.when(
                        data: (hindiSong) {
                          return SizedBox(
                            height: 125.h,
                            child: ListView.builder(
                              shrinkWrap: true,

                              physics: NeverScrollableScrollPhysics(),
                              itemCount: hindiSong.length,
                              itemBuilder: (context, index) {
                                final track = hindiSong[index];

                                String formattedTime({
                                  required int timeInSecond,
                                }) {
                                  int sec = timeInSecond % 60;
                                  int min = (timeInSecond / 60).floor();
                                  String minute = min < 10 ? "0$min" : "$min";
                                  String second = sec < 10 ? "0$sec" : "$sec";
                                  return "$minute : $second";
                                }

                                String? imageUrl = track.albumImage;

                                if (track.albumImage == "") {
                                  imageUrl =
                                      "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
                                } else {
                                  imageUrl = track.albumImage;
                                }
                                return Card(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: ListTile(
                                      tileColor: Colors.transparent,
                                      leading:
                                          track.albumImage != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                child: Image.network(
                                                  imageUrl ??
                                                      AppString
                                                          .defaultMusicLogo,
                                                  fit: BoxFit.cover,
                                                  width: 60.w,
                                                ),
                                              )
                                              : const Icon(Icons.music_note),
                                      title: AppText(
                                        textName: track.name ?? 'N/A',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        textColor: Color(AppColors.blueThird),
                                      ),
                                      subtitleTextStyle: GoogleFonts.poppins(
                                        color: Colors.grey,
                                      ),
                                      dense: true,
                                      hoverColor: Colors.transparent,
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      textName:
                                                          track.albumName ??
                                                          'Unknown album name',
                                                      fontSize: 12.sp,
                                                      textColor: Color(
                                                        AppColors
                                                            .blueExtraLight,
                                                      ),
                                                    ),
                                                    AppText(
                                                      textName:
                                                          track.artistName ??
                                                          "Unknown artist name",
                                                      fontSize: 12.sp,
                                                      textColor: Color(
                                                        AppColors
                                                            .blueExtraLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AppText(
                                                textName: formattedTime(
                                                  timeInSecond:
                                                      track.duration?.toInt() ??
                                                      0,
                                                ),
                                                fontSize: 14.sp,
                                                textColor: Color(
                                                  AppColors.blueLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => MusicPlayer(
                                                  songList: hindiSong,
                                                  initialIndex: index,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        loading: () => Center(child: appLoader()),
                        error:
                            (err, stack) => Center(
                              child: Text(
                                'Error: $err',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        "Your Top Mixes",
                        style: GoogleFonts.poppins(
                          color: Color(AppColors.lightText),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 130.h,
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: mixSongList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MusicTrackList(
                                          "All",
                                          musicType: 1,
                                          genre: '',
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "${mixSongList[index]['image']}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${mixSongList[index]['name']}",
                                    style: GoogleFonts.poppins(
                                      color: Color(AppColors.lightText),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            fontSize: 18.sp,
                            textName: "Artist",
                            fontWeight: FontWeight.w500,
                            textColor: Color(AppColors.lightText),
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint("onTap()");
                              myPushNavigator(context, ArtistList());
                            },
                            child: AppText(
                              fontSize: 14.sp,
                              textName: "View all",
                              fontWeight: FontWeight.w500,
                              textColor: Color(AppColors.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      artisAsync.when(
                        data: (artist) {
                          return SizedBox(
                            height: 150.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  artist.length >= 10 ? 10 : artist.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String? imageUrl = artist[index].image;
                                if (artist[index].image == "") {
                                  imageUrl =
                                      "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
                                } else {
                                  imageUrl = artist[index].image;
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      myPushNavigator(
                                        context,
                                        ArtistDetails(
                                          date: artist[index].joindate,
                                          id: artist[index].id,
                                          image: imageUrl,
                                          name: artist[index].name,
                                          share: artist[index].shareurl,
                                          short: artist[index].shorturl,
                                          website: artist[index].website,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: Image.network(
                                            imageUrl ??
                                                "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                                            fit: BoxFit.cover,
                                            height: 80.h,
                                            width: 90.w,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        AppText(
                                          fontSize: 18.sp,
                                          textName: artist[index].name ?? "",
                                          textColor: Color(AppColors.lightText),
                                        ),
                                        AppText(
                                          fontSize: 14.sp,
                                          textName:
                                              artist[index].joindate ?? "",
                                          textColor: Color(AppColors.lightText),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        loading: () => SizedBox(),
                        error:
                            (e, _) => Text(
                              "Error loading user",
                              style: GoogleFonts.poppins(
                                color: Colors.redAccent,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => Center(child: appLoader()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
