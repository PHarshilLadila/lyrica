import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:lyrica/modules/home/widget/three_d_card.dart';
import 'package:lyrica/modules/music%20player/view/favorite_music_screen.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:lyrica/modules/music%20track/view/music_track_list.dart';
import 'package:lyrica/modules/playlist/view%20playlist/view_playlist_screen.dart';
import 'package:lyrica/modules/playlist/widget/enter_playlist_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String name;
  final String token;
  const HomeScreen(this.name, this.token, {super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String userLocalId = "";
  String userLocalName = "";

  @override
  void initState() {
    super.initState();
    getUserId();
    Future.microtask(() {
      // ignore: unused_result
      ref.refresh(userModelProvider);
    });
  }

  void getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final id = preferences.getString("userUID");
    final name = preferences.getString("userName");
    setState(() {
      userLocalId = id ?? "N/A";
      userLocalName = name ?? "N/A";
      debugPrint("User Local Name: $userLocalName");
      debugPrint("User Local ID: $userLocalId");
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final userModelAsync = ref.watch(userModelProvider);
    final artisAsync = ref.watch(artistDataProvider);
    final hindiSongAsync = ref.watch(hindiSongDataProvider);

    var cardtext = [
      AppLocalizations.of(context)!.playYourFevoriteMusic,
      AppLocalizations.of(context)!.createYourOwnPlaylist,
      AppLocalizations.of(context)!.playYourFavoritePlaylist,
    ];
    var imageList = [
      AppImages.musicPixel,
      AppImages.musicPlaylistPixel,
      AppImages.favoritePixel,
    ];
    var cardButtontext = [
      AppLocalizations.of(context)!.playNow,
      AppLocalizations.of(context)!.createNow,
      AppLocalizations.of(context)!.playNow,
    ];
    var onButtonPress = [
      () {
        debugPrint("Play Fevorite Music");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoriteMusicScreen()),
        );
      },
      () {
        debugPrint("Create your PlayList");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EnterPlayListName()),
        );
      },
      () {
        debugPrint("Play Fevorite Playlist");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPlaylistScreen()),
        );
      },
    ];

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: AppText(text: "User not found"));
        }
        return Container(
          decoration: BoxDecoration(gradient: backgroundGradient()),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(197, 0, 43, 53),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(197, 0, 43, 53),
                  child: userModelAsync.when(
                    data: (userModel) {
                      // final displayInitial =
                      //     (user.displayName != null &&
                      //             user.displayName!.isNotEmpty)
                      //         ? user.displayName![0].toUpperCase()
                      //         : (userModel?.username.isNotEmpty == true)
                      //         ? userModel!.username[0].toUpperCase()
                      //         : "N";
                      final profileInitial =
                          userModel?.image ?? AppImages.avatar;
                      debugPrint("user Profile Image$profileInitial");
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            (profileInitial.startsWith("http") ||
                                    profileInitial.startsWith("https"))
                                ? Image.network(
                                  profileInitial,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImages.avatar,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.asset(
                                  profileInitial.isNotEmpty
                                      ? profileInitial
                                      : AppImages.avatar,
                                  fit: BoxFit.cover,
                                ),
                      );

                      // AppText(
                      //   textName: displayInitial,
                      //   fontSize: 18.sp,
                      //   fontWeight: FontWeight.bold,
                      //   textColor: Color(AppColors.lightText),
                      // );
                    },
                    loading: () => SizedBox(),
                    error:
                        (e, _) => AppText(
                          text: "Error loading user",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.redAccent,
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
                  AppText(
                    text: AppLocalizations.of(context)!.welcome,
                    // text: "Welcome back!",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    textColor: Color(AppColors.lightText),
                  ),
                  userModelAsync.when(
                    data: (userModel) {
                      final displayName = user.displayName;
                      final username = userModel?.username;

                      final displayText =
                          (displayName != null && displayName.isNotEmpty)
                              ? displayName
                              : (username != null && username.isNotEmpty)
                              ? username
                              : "N/A";

                      debugPrint("Display Name => $displayText");

                      return AppText(
                        text: AppLocalizations.of(
                          context,
                        )!.greetingWithName(displayText),
                        // text: displayText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Color(AppColors.lightText),
                      );
                    },
                    loading: () => const SizedBox(),
                    error:
                        (e, _) => AppText(
                          text: "Error loading user",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.redAccent,
                        ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FavoriteMusicScreen(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    AppImages.likeIconPixel,
                    color: Color(AppColors.primaryColor),
                    width: 25.w,
                    // color: Color.fromARGB(255, 116, 215, 240),
                  ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider.builder(
                        itemCount: imageList.length,
                        itemBuilder:
                            (
                              BuildContext context,
                              int itemIndex,
                              int pageViewIndex,
                            ) => Skewed3DCard(
                              imagePath: imageList[itemIndex],
                              cardText: cardtext[itemIndex],
                              buttonText: cardButtontext[itemIndex],
                              onButtonPress: onButtonPress[itemIndex],
                            ),
                        options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 0.75,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          enableInfiniteScroll: true,
                          autoPlayCurve: Curves.easeInOut,
                          scrollPhysics: BouncingScrollPhysics(),
                          animateToClosest: true,
                          disableCenter: true,
                        ),
                      ),
                      SizedBox(height: 18.h),

                      AppText(
                        text: AppLocalizations.of(context)!.yourTopMixes,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        textColor: Color(AppColors.lightText),
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
                          itemCount: mixSongList(context).length,
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
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "${mixSongList(context)[index]['image']}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: AppText(
                                    text:
                                        "${mixSongList(context)[index]['name']}",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(AppColors.lightText),
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
                            text: AppLocalizations.of(context)!.artist,
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
                              text: AppLocalizations.of(context)!.viewAll,
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
                            height: 160.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  artist.length >= 10 ? 10 : artist.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String? imageUrl = artist[index].image;
                                if (artist[index].image == "") {
                                  imageUrl = AppString.defaultImageLogo;
                                  // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
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
                                            12.sp,
                                          ),
                                          child: Image.network(
                                            imageUrl ??
                                                AppString.defaultImageLogo,
                                            // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                                            fit: BoxFit.cover,
                                            height: 80.h,
                                            width: 90.w,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        AppText(
                                          fontSize: 16.sp,
                                          text: artist[index].name ?? "",
                                          textColor: Color(AppColors.lightText),
                                        ),
                                        AppText(
                                          fontSize: 12.sp,
                                          text: artist[index].joindate ?? "",
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
                            (e, _) => AppText(
                              text: "Error loading user",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              textColor: Colors.redAccent,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!.hindiVersion,
                            fontSize: 18.sp,
                            textColor: Color(AppColors.lightText),
                            fontWeight: FontWeight.w500,
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint("onTap() of view all hindi song");
                              myPushNavigator(context, HindiMusicList());
                            },
                            child: AppText(
                              fontSize: 14.sp,
                              text: AppLocalizations.of(context)!.viewAll,
                              fontWeight: FontWeight.w500,
                              textColor: Color(AppColors.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      hindiSongAsync.when(
                        data: (hindiSong) {
                          return Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: BoxDecoration(
                              color: Colors.white12,

                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            height: MediaQuery.of(context).size.height / 2.64,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
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
                                  imageUrl = AppString.defaultImageLogo;
                                } else {
                                  imageUrl = track.albumImage;
                                }
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                  borderOnForeground: true,
                                  color: Color.fromARGB(255, 5, 44, 51),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: ListTile(
                                      tileColor: Color.fromARGB(255, 5, 44, 51),
                                      leading:
                                          track.albumImage != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.sp),
                                                child: Image.network(
                                                  imageUrl ??
                                                      AppString
                                                          .defaultMusicLogo,
                                                  fit: BoxFit.cover,
                                                  width: 65.w,
                                                ),
                                              )
                                              : const Icon(Icons.music_note),
                                      title: AppText(
                                        // text: getLocalizedTextFromAPI(
                                        //   track.toJson(),
                                        //   context,
                                        //   'name',
                                        // ),
                                        text: track.name ?? 'N/A',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        textColor: Color(AppColors.blueThird),
                                      ),
                                      subtitleTextStyle: GoogleFonts.poppins(
                                        color: Colors.grey,
                                      ),
                                      dense: true,
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
                                                      text:
                                                          track.albumName ??
                                                          'Unknown album name',
                                                      fontSize: 12.sp,
                                                      textColor: Color(
                                                        AppColors
                                                            .blueExtraLight,
                                                      ),
                                                    ),
                                                    AppText(
                                                      text:
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
                                                text: formattedTime(
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
                            (err, stack) =>
                                Center(child: AppText(text: 'Error: $err')),
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
      error: (e, _) => Center(child: AppText(text: "Error: $e")),
    );
  }
}
