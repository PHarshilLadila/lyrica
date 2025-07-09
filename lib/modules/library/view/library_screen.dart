// // // // ignore_for_file: use_build_context_synchronously, deprecated_member_use
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:lyrica/common/utils/utils.dart';
// // // import 'package:lyrica/common/widget/app_main_button.dart';
// // // import 'package:lyrica/core/constant/app_colors.dart';
// // // import 'package:lyrica/core/constant/app_images.dart';
// // // import 'package:lyrica/core/providers/provider.dart';
// // // import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// // //
// // // class LibraryScreen extends ConsumerStatefulWidget {
// // //   const LibraryScreen({super.key});
// // //
// // //   @override
// // //   ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
// // // }
// // //
// // // class _LibraryScreenState extends ConsumerState<LibraryScreen> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final auth = ref.read(authControllerProvider);
// // //
// // //     final userAsync = ref.watch(authStateProvider);
// // //
// // //     return userAsync.when(
// // //       data: (user) {
// // //         if (user == null) return const Center(child: Text("User not found"));
// // //
// // //         return Container(
// // //           decoration: BoxDecoration(gradient: backgroundGradient()),
// // //
// // //           child: Scaffold(
// // //             backgroundColor: const Color.fromARGB(221, 39, 39, 39),
// // //             appBar: AppBar(
// // //               leading: Padding(
// // //                 padding: const EdgeInsets.only(left: 10.0),
// // //                 child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(AppImages.logoWithoutBG)),
// // //               ),
// // //               elevation: 0,
// // //               toolbarHeight: 90,
// // //               backgroundColor: Colors.transparent,
// // //               title: Text(
// // //                 "Your Library",
// // //                 style: GoogleFonts.poppins(color: Color(AppColors.lightText), fontSize: 22.sp, fontWeight: FontWeight.w500),
// // //               ),
// // //               actions: [
// // //                 IconButton(
// // //                   onPressed: () async {
// // //                     await auth.signOut();
// // //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GoogleLoginScreen()));
// // //                     showSnackBar(context, "Sign out Successfully..!", Color(AppColors.successColor));
// // //                   },
// // //                   icon: Image.asset(AppImages.barIcon, width: 25.w),
// // //                 ),
// // //                 IconButton(onPressed: () {}, icon: Image.asset(AppImages.settingIcon, width: 25.w)),
// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
// // //                   child: GestureDetector(
// // //                     onTap: () async {
// // //                       await auth.signOut();
// // //                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GoogleLoginScreen()));
// // //                       showSnackBar(context, "Sign out Successfully..!", Color(AppColors.successColor));
// // //                     },
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         gradient: LinearGradient(
// // //                           colors: [Color.fromARGB(106, 29, 178, 183), Color.fromARGB(106, 29, 178, 183), Color.fromARGB(106, 23, 106, 109)],
// // //                         ),
// // //                         border: Border.all(color: Colors.white54, width: 0.5),
// // //                         shape: BoxShape.circle,
// // //                       ),
// // //                       child: Center(
// // //                         child: Padding(
// // //                           padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 12, right: 8),
// // //                           child: FaIcon(FontAwesomeIcons.signOutAlt, color: Color(AppColors.whiteBackground)),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //
// // //             body: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               crossAxisAlignment: CrossAxisAlignment.center,
// // //               children: [
// // //                 IconButton(onPressed: () {}, icon: Icon(Icons.wallet_giftcard, color: Colors.white)),
// // //                 const Center(child: Text("library", style: TextStyle(color: Colors.white))),
// // //                 SizedBox(height: 12.h),
// // //                 AppMainButton(
// // //                   width: 70.w,
// // //                   borderRadius: BorderRadius.circular(12),
// // //                   onPressed: () async {
// // //                     await auth.signOut();
// // //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GoogleLoginScreen()));
// // //                     showSnackBar(context, "Sign out Successfully..!", Color(AppColors.successColor));
// // //                   },
// // //                   gradient: const LinearGradient(
// // //                     begin: Alignment.topLeft,
// // //                     end: Alignment.bottomRight,
// // //                     colors: [Color(AppColors.blueThird), Color(AppColors.blueLight), Color(AppColors.secondaryColor)],
// // //                   ),
// // //                   child: const Text("Sign Out", style: TextStyle(color: Color(AppColors.blackBackground))),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //       loading: () => Center(child: appLoader()),
// // //       error: (e, _) => Center(child: Text("Error: $e")),
// // //     );
// // //   }
// // // }
// // // ignore_for_file: use_build_context_synchronously
// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// // import 'package:lyrica/common/utils/utils.dart';
// // import 'package:lyrica/common/widget/app_main_button.dart';
// // import 'package:lyrica/core/constant/app_colors.dart';
// // import 'package:lyrica/core/constant/app_images.dart';
// // import 'package:lyrica/core/providers/provider.dart';
// // import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// // import 'package:lyrica/modules/library/service/ad_mob_service.dart';

// // class LibraryScreen extends ConsumerStatefulWidget {
// //   const LibraryScreen({super.key});

// //   @override
// //   ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
// // }

// // class _LibraryScreenState extends ConsumerState<LibraryScreen> {
// //   // RewardedAd? _rewardedAd;
// //   // BannerAd? bannerAd;
// //   BannerAd? banner;
// //   InterstitialAd? _interstitialAd;
// //   RewardedAd? _rewardedAd;
// //   int _rewardedScore = 0;

// //   // final String _adUnitId =
// //   //     Platform.isAndroid
// //   //         ? 'ca-app-pub-3779258307133143/6172402894'
// //   //         : 'ca-app-pub-3779258307133143/6172402894';

// //   void _createInterstitialAd() {
// //     InterstitialAd.load(
// //       adUnitId: AdMobService.interstitialAdUnitId ?? "",
// //       request: const AdRequest(),
// //       adLoadCallback: InterstitialAdLoadCallback(
// //         onAdLoaded: (ad) => _interstitialAd = ad,
// //         onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
// //       ),
// //     );
// //   }

// //   void showInterstitialAd() {
// //     if (_interstitialAd != null) {
// //       _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
// //         onAdDismissedFullScreenContent: (ad) {
// //           ad.dispose();
// //           _createInterstitialAd();
// //         },
// //         onAdFailedToShowFullScreenContent: (ad, error) {
// //           ad.dispose();
// //           _createInterstitialAd();
// //         },
// //       );

// //       _interstitialAd?.show();
// //       _interstitialAd = null;
// //     }
// //   }

// //   void createBannerAd() {
// //     banner = BannerAd(
// //       size: AdSize.fullBanner,
// //       adUnitId: AdMobService.bannerAdUnitId ?? "",
// //       listener: AdMobService.bannerListener,
// //       request: const AdRequest(),
// //     )..load();
// //   }

// //   void createRewardedAd() {
// //     RewardedAd.load(
// //       adUnitId: AdMobService.rewardedAdUnitId ?? "",
// //       request: const AdRequest(),
// //       rewardedAdLoadCallback: RewardedAdLoadCallback(
// //         onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
// //         onAdFailedToLoad: (error) => setState(() => _rewardedAd = null),
// //       ),
// //     );
// //   }

// //   void showRewardedAd() {
// //     if (_rewardedAd != null) {
// //       _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
// //         onAdDismissedFullScreenContent: (ad) {
// //           ad.dispose();
// //           createRewardedAd();
// //         },
// //         onAdFailedToShowFullScreenContent: (ad, error) {
// //           ad.dispose();
// //           createRewardedAd();
// //         },
// //       );

// //       _rewardedAd?.show(
// //         onUserEarnedReward: (ad, reward) => setState(() => _rewardedScore++),
// //       );
// //       _rewardedAd = null;
// //     }
// //   }

// //   // void _loadRewardedAd() {
// //   //   RewardedAd.load(
// //   //     adUnitId: _adUnitId,
// //   //     request: const AdRequest(),
// //   //     rewardedAdLoadCallback: RewardedAdLoadCallback(
// //   //       onAdLoaded: (ad) {
// //   //         _rewardedAd = ad;
// //   //         _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
// //   //           onAdDismissedFullScreenContent: (ad) {
// //   //             ad.dispose();
// //   //             _loadRewardedAd(); // Preload the next ad
// //   //           },
// //   //           onAdFailedToShowFullScreenContent: (ad, error) {
// //   //             ad.dispose();
// //   //             _loadRewardedAd(); // Retry loading
// //   //           },
// //   //         );
// //   //         _rewardedAd?.show(
// //   //           onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
// //   //             showSnackBar(
// //   //               context,
// //   //               '🎉 You earned ${rewardItem.amount.toInt()} music minute(s)!',
// //   //               Color(AppColors.successColor),
// //   //             );
 // //   //           },
// //   //         );
// //   //       },
// //   //       onAdFailedToLoad: (error) {
// //   //         debugPrint('Failed to load rewarded ad: $error');
// //   //       },
// //   //     ),
// //   //   );
// //   // }

// //   // @override
// //   // void dispose() {
// //   //   _rewardedAd?.dispose();
// //   //   super.dispose();
// //   // }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _createInterstitialAd();
// //     createRewardedAd();
// //     createBannerAd();
// //     // BannerAd(
// //     //   size: AdSize.banner,
// //     //   adUnitId: _adUnitId,
// //     //   listener: BannerAdListener(
// //     //     onAdLoaded: (ad) {
// //     //       setState(() {
// //     //         // bannerAd = ad as BannerAd;
// //     //       });
// //     //     },
// //     //     onAdFailedToLoad: (ad, error) {
// //     //       debugPrint("failed to load banner ads : ${error.message}");
// //     //       debugPrint("failed to load banner ads : $ad");

// //     //       ad.dispose();
// //     //     },
// //     //   ),
// //     //   request: AdRequest(),
// //     // ).load();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final auth = ref.read(authControllerProvider);
// //     final userAsync = ref.watch(authStateProvider);

// //     return userAsync.when(
// //       data: (user) {
// //         if (user == null) return const Center(child: Text("User not found"));

// //         return Container(
// //           decoration: BoxDecoration(gradient: backgroundGradient()),
// //           child: Scaffold(
// //             backgroundColor: const Color.fromARGB(221, 39, 39, 39),
// //             appBar: AppBar(
// //               leading: Padding(
// //                 padding: const EdgeInsets.only(left: 10.0),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Image.asset(AppImages.logoWithoutBG),
// //                 ),
// //               ),
// //               elevation: 0,
// //               toolbarHeight: 90,
// //               backgroundColor: Colors.transparent,
// //               title: Text(
// //                 "Your Library",
// //                 style: GoogleFonts.poppins(
// //                   color: Color(AppColors.lightText),
// //                   fontSize: 22.sp,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //               actions: [
// //                 IconButton(
// //                   onPressed: () async {
// //                     await auth.signOut();
// //                     Navigator.pushReplacement(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (_) => const GoogleLoginScreen(),
// //                       ),
// //                     );
// //                     showSnackBar(
// //                       context,
// //                       "Sign out Successfully..!",
// //                       Color(AppColors.successColor),
// //                     );
// //                   },
// //                   icon: Image.asset(AppImages.barIcon, width: 25.w),
// //                 ),
// //                 IconButton(
// //                   onPressed: () {},
// //                   icon: Image.asset(AppImages.settingIcon, width: 25.w),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
// //                   child: GestureDetector(
// //                     onTap: () async {
// //                       await auth.signOut();
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (_) => const GoogleLoginScreen(),
// //                         ),
// //                       );
// //                       showSnackBar(
// //                         context,
// //                         "Sign out Successfully..!",
// //                         Color(AppColors.successColor),
// //                       );
// //                     },
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         gradient: const LinearGradient(
// //                           colors: [
// //                             Color.fromARGB(106, 29, 178, 183),
// //                             Color.fromARGB(106, 29, 178, 183),
// //                             Color.fromARGB(106, 23, 106, 109),
// //                           ],
// //                         ),
// //                         border: Border.all(color: Colors.white54, width: 0.5),
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: const Padding(
// //                         padding: EdgeInsets.only(
// //                           left: 12.0,
// //                           top: 12,
// //                           bottom: 12,
// //                           right: 8,
// //                         ),
// //                         child: FaIcon(
// //                           FontAwesomeIcons.signOutAlt,
// //                           color: Color(AppColors.whiteBackground),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             body: Stack(
// //               // mainAxisAlignment: MainAxisAlignment.center,
// //               // crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 // 🎁 Show rewarded ad on press
// //                 // IconButton(
// //                 //   onPressed: () {
// //                 //     _loadRewardedAd();
// //                 //   },
// //                 //   icon: const Icon(Icons.wallet_giftcard, color: Colors.white),
// //                 // ),
// //                 const Center(
// //                   child: Text("library", style: TextStyle(color: Colors.white)),
// //                 ),
// //                 SizedBox(height: 12.h),
// //                 AppMainButton(
// //                   width: 70.w,
// //                   borderRadius: BorderRadius.circular(12),
// //                   onPressed: () async {
// //                     await auth.signOut();
// //                     Navigator.pushReplacement(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (_) => const GoogleLoginScreen(),
// //                       ),
// //                     );
// //                     showSnackBar(
// //                       context,
// //                       "Sign out Successfully..!",
// //                       Color(AppColors.successColor),
// //                     );
// //                   },
// //                   gradient: const LinearGradient(
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                     colors: [
// //                       Color(AppColors.blueThird),
// //                       Color(AppColors.blueLight),
// //                       Color(AppColors.secondaryColor),
// //                     ],
// //                   ),
// //                   child: const Text(
// //                     "Sign Out",
// //                     style: TextStyle(color: Color(AppColors.blackBackground)),
// //                   ),
// //                 ),

// //                 // if (bannerAd != null)
// //                 //   Align(
// //                 //     alignment: Alignment.topCenter,
// //                 //     child: Container(
// //                 //       width: bannerAd!.size.width.toDouble(),
// //                 //       height: bannerAd!.size.height.toDouble(),
// //                 //       child: AdWidget(ad: bannerAd!),
// //                 //     ),
// //                 //   ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //       loading: () => Center(child: appLoader()),
// //       error: (e, _) => Center(child: Text("Error: $e")),
// //     );
// //   }
// // }
// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_main_button.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_images.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// import 'package:lyrica/modules/library/service/ad_mob_service.dart';
// import 'package:lyrica/modules/library/widget/rounded_star.dart';

// class LibraryScreen extends ConsumerStatefulWidget {
//   const LibraryScreen({super.key});

//   @override
//   ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
// }

// class _LibraryScreenState extends ConsumerState<LibraryScreen> {
//   BannerAd? bannerAd;
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;
//   int _rewardedScore = 0;

//   @override
//   void initState() {
//     super.initState();
//     _createInterstitialAd();
//     _createRewardedAd();
//     _createBannerAd();
//   }

//   void _createBannerAd() {
//     bannerAd = BannerAd(
//       size: AdSize.banner,
//       adUnitId: AdMobService.bannerAdUnitId ?? '',
//       listener: AdMobService.bannerListener,
//       request: const AdRequest(),
//     )..load();
//   }

//   void _createInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: AdMobService.interstitialAdUnitId ?? '',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) => _interstitialAd = ad,
//         onAdFailedToLoad: (error) => _interstitialAd = null,
//       ),
//     );
//   }

//   void _createRewardedAd() {
//     RewardedAd.load(
//       adUnitId: AdMobService.rewardedAdUnitId ?? '',
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) => _rewardedAd = ad,
//         onAdFailedToLoad: (error) => _rewardedAd = null,
//       ),
//     );
//   }

//   void _showRewardedAd() {
//     if (_rewardedAd != null) {
//       _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           ad.dispose();
//           _createRewardedAd();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           ad.dispose();
//           _createRewardedAd();
//         },
//       );
//       _rewardedAd?.show(
//         onUserEarnedReward: (ad, reward) {
//           setState(() {
//             _rewardedScore += reward.amount.toInt();
//           });
//           showSnackBar(
//             context,
//             '🎉 You earned ${reward.amount.toInt()} points!',
//             Color(AppColors.successColor),
//           );
//         },
//       );
//       _rewardedAd = null;
//     } else {
//       showSnackBar(context, "Rewarded ad not ready", Colors.red);
//     }
//   }

//   void _showInterstitialAd() {
//     if (_interstitialAd != null) {
//       _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           ad.dispose();
//           _createInterstitialAd();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           ad.dispose();
//           _createInterstitialAd();
//         },
//       );
//       _interstitialAd?.show();
//       _interstitialAd = null;
//     }
//   }

//   @override
//   void dispose() {
//     bannerAd?.dispose();
//     _rewardedAd?.dispose();
//     _interstitialAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.read(authControllerProvider);
//     final authUserData = ref.read(userModelStateProvider);
//     final userAsync = ref.watch(authStateProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) return const Center(child: Text("User not found"));

//         return Container(
//           decoration: BoxDecoration(gradient: backgroundGradient()),
//           child: Scaffold(
//             backgroundColor: const Color.fromARGB(221, 39, 39, 39),
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               toolbarHeight: 90,
//               leading: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(AppImages.logoWithoutBG),
//               ),
//               title: Text(
//                 "Your Library",
//                 style: GoogleFonts.poppins(
//                   color: Color(AppColors.lightText),
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: Image.asset(AppImages.barIcon, width: 25.w),
//                   onPressed: () => _showInterstitialAd(),
//                 ),
//                 IconButton(
//                   icon: Image.asset(AppImages.settingIcon, width: 25.w),
//                   onPressed: () {},
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     await auth.signOut();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const GoogleLoginScreen(),
//                       ),
//                     );
//                     showSnackBar(
//                       context,
//                       "Signed out successfully!",
//                       Color(AppColors.successColor),
//                     );
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromARGB(106, 29, 178, 183),
//                           Color.fromARGB(106, 23, 106, 109),
//                         ],
//                       ),
//                       border: Border.all(color: Colors.white54, width: 0.5),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: const FaIcon(
//                         FontAwesomeIcons.signOutAlt,
//                         color: Color(AppColors.whiteBackground),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // ...existing code...
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 24.h,
//                       horizontal: 8.w,
//                     ),
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 8),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Color(AppColors.blueLight).withOpacity(0.15),
//                             Color(AppColors.secondaryColor).withOpacity(0.10),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(AppColors.darkBlue).withOpacity(0.08),
//                             blurRadius: 16,
//                             offset: Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16.w),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Hey ${authUserData?.username ?? ""},",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 26,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(
//                                         AppColors.whiteBackground,
//                                       ).withOpacity(0.8),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     "Do you know about rewards?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(
//                                         AppColors.whiteBackground,
//                                       ).withOpacity(0.6),
//                                     ),
//                                   ),
//                                   SizedBox(height: 18),
//                                   ElevatedButton.icon(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Color(
//                                         AppColors.primaryColor,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(18),
//                                       ),
//                                       elevation: 0,
//                                     ),
//                                     onPressed: _showRewardedAd,
//                                     icon: Icon(
//                                       Icons.card_giftcard,
//                                       color: Colors.white,
//                                     ),
//                                     label: Text(
//                                       "Earn Now",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                     top: 24,
//                                     bottom: 24,
//                                     right: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Color(
//                                           AppColors.secondaryColor,
//                                         ).withOpacity(0.1),
//                                         blurRadius: 24,
//                                         offset: Offset(0, 12),
//                                       ),
//                                     ],
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: Image.asset(
//                                       "assets/image/roundedShap.png",
//                                       fit: BoxFit.cover,
//                                       height: 240,
//                                       width: double.infinity,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 100,
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Color(
//                                                 AppColors.primaryColor,
//                                               ).withOpacity(0.25),
//                                               blurRadius: 18,
//                                               offset: Offset(0, 8),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Image.asset(
//                                           "assets/image/rewardIcon.png",
//                                           height: 80,
//                                         ),
//                                       ),
//                                       // SizedBox(height: 10),
//                                       // Text(
//                                       //   "Earn Reward",
//                                       //   style: GoogleFonts.fuzzyBubbles(
//                                       //     fontSize: 18,
//                                       //     fontWeight: FontWeight.bold,
//                                       //     color: Color(AppColors.darkBlue),
//                                       //     letterSpacing: 1.2,
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ...existing code...
//                   Center(
//                     child: Text(
//                       "library",
//                       style: TextStyle(color: Colors.white, fontSize: 18.sp),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   AppMainButton(
//                     width: 200.w,
//                     borderRadius: BorderRadius.circular(12),
//                     onPressed: _showRewardedAd,
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
//                     ),
//                     child: const Text(
//                       "Watch Ad to Earn Reward",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   AppMainButton(
//                     width: 200.w,
//                     borderRadius: BorderRadius.circular(12),
//                     onPressed: () async {
//                       await auth.signOut();
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const GoogleLoginScreen(),
//                         ),
//                       );
//                       showSnackBar(
//                         context,
//                         "Signed out successfully!",
//                         Color(AppColors.successColor),
//                       );
//                     },
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(AppColors.blueThird),
//                         Color(AppColors.blueLight),
//                         Color(AppColors.secondaryColor),
//                       ],
//                     ),
//                     child: const Text(
//                       "Sign Out",
//                       style: TextStyle(color: Color(AppColors.blackBackground)),
//                     ),
//                   ),
//                   if (bannerAd != null)
//                     RotatedBox(
//                       quarterTurns: 0,
//                       child: SizedBox(
//                         height: bannerAd!.size.height.toDouble(),
//                         width: bannerAd!.size.width.toDouble(),
//                         child: AdWidget(ad: bannerAd!),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       loading: () => Center(child: appLoader()),
//       error: (e, _) => Center(child: Text("Error: $e")),
//     );
//   }
// }

 // ignore_for_file: use_build_context_synchronously, deprecated_member_use
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/library/service/ad_mob_service.dart';

final rewardPointsProvider = StreamProvider<int>((ref) async* {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) yield 0;
  final doc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
  await for (final snap in doc.snapshots()) {
    yield (snap.data()?['rewardPoints'] ?? 0) as int;
  }
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  BannerAd? bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _createRewardedAd();
    _createBannerAd();
  }

  void _createBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId ?? '',
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId ?? '',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId ?? '',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  Future<void> _addRewardPoints(int points) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
      transaction.update(doc, {'rewardPoints': current + points});
    });
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) async {
          await _addRewardPoints(2);
          showSnackBar(
            context,
            '🎉 You earned 2 points!',
            Color(AppColors.successColor),
          );
        },
      );
      _rewardedAd = null;
    } else {
      showSnackBar(context, "Rewarded ad not ready", Colors.red);
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd?.show();
      _interstitialAd = null;
    }
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);
    final authUserData = ref.read(userModelStateProvider);
    final userAsync = ref.watch(authStateProvider);
    final rewardPointsAsync = ref.watch(rewardPointsProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text("User not found"));

        return Container(
          decoration: BoxDecoration(gradient: backgroundGradient()),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(221, 39, 39, 39),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AppImages.logoWithoutBG),
              ),
              title: Text(
                "Your Library",
                style: GoogleFonts.poppins(
                  color: Color(AppColors.lightText),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  icon: Image.asset(AppImages.barIcon, width: 25.w),
                  onPressed: () => _showInterstitialAd(),
                ),
                IconButton(
                  icon: Image.asset(AppImages.settingIcon, width: 25.w),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () async {
                    await auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoogleLoginScreen(),
                      ),
                    );
                    showSnackBar(
                      context,
                      "Signed out successfully!",
                      Color(AppColors.successColor),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(106, 29, 178, 183),
                          Color.fromARGB(106, 23, 106, 109),
                        ],
                      ),
                      border: Border.all(color: Colors.white54, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const FaIcon(
                        FontAwesomeIcons.signOutAlt,
                        color: Color(AppColors.whiteBackground),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Reward Card
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 8.w,
                          left: 8.w,
                          bottom: 24.h,
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(AppColors.blueLight).withOpacity(0.15),
                                Color(
                                  AppColors.secondaryColor,
                                ).withOpacity(0.10),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  AppColors.darkBlue,
                                ).withOpacity(0.08),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 24.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hey ${authUserData?.username ?? ""},",
                                        style: GoogleFonts.poppins(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Color(
                                            AppColors.whiteBackground,
                                          ).withOpacity(0.8),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Do you know about rewards?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                            AppColors.whiteBackground,
                                          ).withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 18),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(
                                            AppColors.primaryColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: _showRewardedAd,
                                        icon: Icon(
                                          Icons.card_giftcard,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "Earn Now",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 24,
                                        bottom: 24,
                                        right: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              AppColors.secondaryColor,
                                            ).withOpacity(0.1),
                                            blurRadius: 24,
                                            offset: Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          "assets/image/roundedShap.png",
                                          fit: BoxFit.cover,
                                          height: 240,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 100,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(
                                                    AppColors.primaryColor,
                                                  ).withOpacity(0.25),
                                                  blurRadius: 18,
                                                  offset: Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                              "assets/image/rewardIcon.png",
                                              height: 80,
                                            ),
                                          ),

                                          // Reward Points Badge
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      rewardPointsAsync.when(
                        data: (points) {
                          if (points == 0) return SizedBox.shrink();
                          return Positioned(
                            bottom: 16,
                            left: 150,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Color(AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      AppColors.primaryColor,
                                    ).withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "$points Points",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loading:
                            () => Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: CircularProgressIndicator(
                                color: Color(AppColors.primaryColor),
                                strokeWidth: 2,
                              ),
                            ),
                        error: (e, _) => SizedBox.shrink(),
                      ),
                    ],
                  ),
                  // ...other UI...
                  Center(
                    child: Text(
                      "library",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppMainButton(
                    width: 200.w,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _showRewardedAd,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    ),
                    child: const Text(
                      "Watch Ad to Earn Reward",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppMainButton(
                    width: 200.w,
                    borderRadius: BorderRadius.circular(12),
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
                        "Signed out successfully!",
                        Color(AppColors.successColor),
                      );
                    },
                    gradient: const LinearGradient(
                      colors: [
                        Color(AppColors.blueThird),
                        Color(AppColors.blueLight),
                        Color(AppColors.secondaryColor),
                      ],
                    ),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Color(AppColors.blackBackground)),
                    ),
                  ),
                  if (bannerAd != null)
                    RotatedBox(
                      quarterTurns: 0,
                      child: SizedBox(
                        height: bannerAd!.size.height.toDouble(),
                        width: bannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: bannerAd!),
                      ),
                    ),
                ],
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
