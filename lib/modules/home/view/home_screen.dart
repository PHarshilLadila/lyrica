// // ignore_for_file: use_build_context_synchronously

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lyrica/common/utils/list_helper.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_images.dart';
// import 'package:lyrica/core/constant/app_string.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/modules/home/music/view/hindi_music_list.dart';
// import 'package:lyrica/modules/home/view/artist_details.dart';
// import 'package:lyrica/modules/home/view/artist_list.dart';
// import 'package:lyrica/modules/music%20player/view/music_player.dart';
// import 'package:lyrica/modules/music%20track/view/music_track_list.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   final String name;
//   final String token;
//   const HomeScreen(this.name, this.token, {super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   String userLocalId = "";
//   String userLocalName = "";
//   void getUserId() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     final id = preferences.getString("userUID");
//     final name = preferences.getString("userName");
//     setState(() {
//       userLocalId = id ?? "N/A";
//       userLocalName = name ?? "N/A";
//       debugPrint("User Local Name: $userLocalName");
//       debugPrint("User Local ID: $userLocalId");
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserId();
//     Future.microtask(() {
//       // ignore: unused_result
//       ref.refresh(userModelProvider);
//     });
//   }

//   Future<void> checkDeviceConnectivity() async {
//     final result = await Connectivity().checkConnectivity();
//     setState(() => "Internet Checking..");
//     switch (result as ConnectivityResult) {
//       case ConnectivityResult.mobile:
//         setState(() {
//           showSnackBar(
//             context,
//             "Connected to mobile network",
//             Color(AppColors.darkYellow),
//           );
//         });
//         break;

//       case ConnectivityResult.bluetooth:
//         setState(() {
//           showSnackBar(
//             context,
//             "Connected to mobile bluetooth",
//             Color(AppColors.errorColor),
//           );
//         });
//         break;
//       case ConnectivityResult.wifi:
//         setState(() {
//           showSnackBar(
//             context,
//             "Connected to mobile wifi",
//             Color(AppColors.errorColor),
//           );
//         });
//         break;
//       case ConnectivityResult.ethernet:
//         setState(() {
//           showSnackBar(
//             context,
//             "Connected to mobile ethernet",
//             Color(AppColors.errorColor),
//           );
//         });
//         break;
//       case ConnectivityResult.none:
//         showSnackBar(
//           context,
//           "Please Connect with your Internet..!",
//           Color(AppColors.successColor),
//         );
//         break;
//       case ConnectivityResult.vpn:
//         debugPrint("Connected to mobile vpn");
//         break;
//       case ConnectivityResult.other:
//         setState(() {
//           showSnackBar(
//             context,
//             "error in connectivity",
//             Color(AppColors.errorColor),
//           );
//         });
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userAsync = ref.watch(authStateProvider);
//     final userModelAsync = ref.watch(userModelProvider);
//     final artisAsync = ref.watch(artistDataProvider);
//     final hindiSongAsync = ref.watch(hindiSongDataProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) return const Center(child: AppText(   textName:"User not found"));

//         return Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(gradient: backgroundGradient()),
//           child: Scaffold(
//             backgroundColor: const Color.fromARGB(221, 27, 27, 27),
//             appBar: AppBar(
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: CircleAvatar(
//                   backgroundColor: Color(AppColors.primaryColor),
//                   child: userModelAsync.when(
//                     data: (userModel) {
//                       final displayInitial =
//                           (user.displayName != null &&
//                                   user.displayName!.isNotEmpty)
//                               ? user.displayName![0]
//                               : (userModel?.username.isNotEmpty == true)
//                               ? userModel!.username[0]
//                               : "N";
//                       return AppText(   textName:
//                         displayInitial,
//                         style: GoogleFonts.poppins(
//                           color: Color(AppColors.lightText),
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       );
//                     },
//                     loading: () => SizedBox(),

//                     error:
//                         (e, _) => AppText(   textName:
//                           "Error loading user",
//                           style: GoogleFonts.poppins(
//                             color: Colors.redAccent,
//                             fontSize: 11.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                   ),
//                 ),
//               ),
//               elevation: 0,
//               toolbarHeight: 90,
//               backgroundColor: Colors.transparent,
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(   textName:
//                     "Welcome back!",
//                     style: GoogleFonts.poppins(
//                       color: Color(AppColors.lightText),
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   userModelAsync.when(
//                     data: (userModel) {
//                       final displayName = user.displayName;
//                       final username = userModel?.username;

//                       final displayText =
//                           (displayName != null && displayName.isNotEmpty)
//                               ? displayName
//                               : (username != null && username.isNotEmpty)
//                               ? username
//                               : "N/A";

//                       debugPrint("Display Name => $displayText");

//                       return AppText(   textName:
//                         displayText,
//                         style: GoogleFonts.poppins(
//                           color: Color(AppColors.lightText),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       );
//                     },
//                     loading: () => const SizedBox(),
//                     error:
//                         (e, _) => AppText(   textName:
//                           "Error loading user",
//                           style: GoogleFonts.poppins(
//                             color: Colors.redAccent,
//                             fontSize: 11.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Image.asset(AppImages.barIcon, width: 25.w),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Image.asset(AppImages.notificationIcon, width: 25.w),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Image.asset(AppImages.settingIcon, width: 25.w),
//                 ),
//               ],
//             ),
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(   textName:
//                             "Hindi Version",
//                             style: GoogleFonts.poppins(
//                               color: Color(AppColors.lightText),
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               debugPrint("onTap() of view all hindi song");
//                               myPushNavigator(context, HindiMusicList());
//                             },
//                             child: AppAppText(   textName:
//                               fontSize: 14.sp,
//                               textName: "View all",
//                               fontWeight: FontWeight.w500,
//                               textColor: Color(AppColors.secondaryColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       hindiSongAsync.when(
//                         data: (hindiSong) {
//                           return SizedBox(
//                             height: 125.h,
//                             child: ListView.builder(
//                               shrinkWrap: true,

//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: hindiSong.length,
//                               itemBuilder: (context, index) {
//                                 final track = hindiSong[index];

//                                 String formattedTime({
//                                   required int timeInSecond,
//                                 }) {
//                                   int sec = timeInSecond % 60;
//                                   int min = (timeInSecond / 60).floor();
//                                   String minute = min < 10 ? "0$min" : "$min";
//                                   String second = sec < 10 ? "0$sec" : "$sec";
//                                   return "$minute : $second";
//                                 }

//                                 String? imageUrl = track.albumImage;

//                                 if (track.albumImage == "") {
//                                   imageUrl =
//                                       "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
//                                 } else {
//                                   imageUrl = track.albumImage;
//                                 }
//                                 return Card(
//                                   color: Colors.black12,
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: 8.0,
//                                     ),
//                                     child: ListTile(
//                                       tileColor: Colors.transparent,
//                                       leading:
//                                           track.albumImage != null
//                                               ? ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 child: Image.network(
//                                                   imageUrl ??
//                                                       AppString
//                                                           .defaultMusicLogo,
//                                                   fit: BoxFit.cover,
//                                                   width: 60.w,
//                                                 ),
//                                               )
//                                               : const Icon(Icons.music_note),
//                                       title: AppAppText(   textName:
//                                         textName: track.name ?? 'N/A',
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.bold,
//                                         textColor: Color(AppColors.blueThird),
//                                       ),
//                                       subtitleTextStyle: GoogleFonts.poppins(
//                                         color: Colors.grey,
//                                       ),
//                                       dense: true,
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     AppAppText(   textName:
//                                                       textName:
//                                                           track.albumName ??
//                                                           'Unknown album name',
//                                                       fontSize: 12.sp,
//                                                       textColor: Color(
//                                                         AppColors
//                                                             .blueExtraLight,
//                                                       ),
//                                                     ),
//                                                     AppAppText(   textName:
//                                                       textName:
//                                                           track.artistName ??
//                                                           "Unknown artist name",
//                                                       fontSize: 12.sp,
//                                                       textColor: Color(
//                                                         AppColors
//                                                             .blueExtraLight,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               AppAppText(   textName:
//                                                 textName: formattedTime(
//                                                   timeInSecond:
//                                                       track.duration?.toInt() ??
//                                                       0,
//                                                 ),
//                                                 fontSize: 14.sp,
//                                                 textColor: Color(
//                                                   AppColors.blueLight,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder:
//                                                 (context) => MusicPlayer(
//                                                   songList: hindiSong,
//                                                   initialIndex: index,
//                                                 ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                         loading: () => Center(child: appLoader()),
//                         error:
//                             (err, stack) => Center(
//                               child: AppText(   textName:
//                                 'Error: $err',
//                                 style: GoogleFonts.poppins(),
//                               ),
//                             ),
//                       ),
//                       SizedBox(height: 10.h),

// ignore_for_file: use_build_context_synchronously

//                       AppText(   textName:
//                         "Your Top Mixes",
//                         style: GoogleFonts.poppins(
//                           color: Color(AppColors.lightText),
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       SizedBox(
//                         height: 130.h,
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           physics: ScrollPhysics(),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 1,
//                                 childAspectRatio: 1.5,
//                                 mainAxisSpacing: 12,
//                               ),
//                           itemCount: mixSongList.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => MusicTrackList(
//                                           "All",
//                                           musicType: 1,
//                                           genre: '',
//                                         ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                   borderRadius: BorderRadius.circular(12),
//                                   image: DecorationImage(
//                                     image: AssetImage(
//                                       "${mixSongList[index]['image']}",
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: AppText(   textName:
//                                     "${mixSongList[index]['name']}",
//                                     style: GoogleFonts.poppins(
//                                       color: Color(AppColors.lightText),
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppAppText(   textName:
//                             fontSize: 18.sp,
//                             textName: "Artist",
//                             fontWeight: FontWeight.w500,
//                             textColor: Color(AppColors.lightText),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               debugPrint("onTap()");
//                               myPushNavigator(context, ArtistList());
//                             },
//                             child: AppAppText(   textName:
//                               fontSize: 14.sp,
//                               textName: "View all",
//                               fontWeight: FontWeight.w500,
//                               textColor: Color(AppColors.secondaryColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12.h),
//                       artisAsync.when(
//                         data: (artist) {
//                           return SizedBox(
//                             height: 160.h,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount:
//                                   artist.length >= 10 ? 10 : artist.length,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 String? imageUrl = artist[index].image;
//                                 if (artist[index].image == "") {
//                                   imageUrl =
//                                       "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
//                                 } else {
//                                   imageUrl = artist[index].image;
//                                 }
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       myPushNavigator(
//                                         context,
//                                         ArtistDetails(
//                                           date: artist[index].joindate,
//                                           id: artist[index].id,
//                                           image: imageUrl,
//                                           name: artist[index].name,
//                                           share: artist[index].shareurl,
//                                           short: artist[index].shorturl,
//                                           website: artist[index].website,
//                                         ),
//                                       );
//                                     },
//                                     child: Column(
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                             100,
//                                           ),
//                                           child: Image.network(
//                                             imageUrl ??
//                                                 "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
//                                             fit: BoxFit.cover,
//                                             height: 80.h,
//                                             width: 90.w,
//                                           ),
//                                         ),
//                                         SizedBox(height: 10.h),
//                                         AppAppText(   textName:
//                                           fontSize: 18.sp,
//                                           textName: artist[index].name ?? "",
//                                           textColor: Color(AppColors.lightText),
//                                         ),
//                                         AppAppText(   textName:
//                                           fontSize: 14.sp,
//                                           textName:
//                                               artist[index].joindate ?? "",
//                                           textColor: Color(AppColors.lightText),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                         loading: () => SizedBox(),
//                         error:
//                             (e, _) => AppText(   textName:
//                               "Error loading user",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.redAccent,
//                                 fontSize: 11.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       loading: () => Center(child: appLoader()),
//       error: (e, _) => Center(child: AppText(   textName:"Error: $e")),
//     );
//   }
// }
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
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final userModelAsync = ref.watch(userModelProvider);
    final artisAsync = ref.watch(artistDataProvider);
    final hindiSongAsync = ref.watch(hindiSongDataProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: AppText(textName: "User not found"));
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
                          textName: "Error loading user",
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
                    textName: "Welcome back!",
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
                        textName: displayText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Color(AppColors.lightText),
                      );
                    },
                    loading: () => const SizedBox(),
                    error:
                        (e, _) => AppText(
                          textName: "Error loading user",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.redAccent,
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
                          AppText(
                            textName: "Hindi Version",
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
                          return Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: BoxDecoration(
                              color: Colors.white30,

                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            height: MediaQuery.of(context).size.height / 2.5,
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
                                  // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
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
                                        textName: track.name ?? 'N/A',
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
                            (err, stack) =>
                                Center(child: AppText(textName: 'Error: $err')),
                      ),
                      SizedBox(height: 16.h),
                      AppText(
                        textName: "Your Top Mixes",
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
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "${mixSongList[index]['image']}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: AppText(
                                    textName: "${mixSongList[index]['name']}",
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
                                          textName: artist[index].name ?? "",
                                          textColor: Color(AppColors.lightText),
                                        ),
                                        AppText(
                                          fontSize: 12.sp,
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
                            (e, _) => AppText(
                              textName: "Error loading user",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              textColor: Colors.redAccent,
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
      error: (e, _) => Center(child: AppText(textName: "Error: $e")),
    );
  }
}
