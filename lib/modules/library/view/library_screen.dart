// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/library/service/ad_mob_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String userLocalId = "N/A";
  String userLocalName = "N/A";
  void getUserIdAndName() async {
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
  void initState() {
    getUserIdAndName();
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
                                        "Hey $userLocalName,",
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

                  // AppMainButton(
                  //   width: 200.w,
                  //   borderRadius: BorderRadius.circular(12),
                  //   onPressed: _showRewardedAd,
                  //   gradient: const LinearGradient(
                  //     colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  //   ),
                  //   child: const Text(
                  //     "Watch Ad to Earn Reward",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  // const SizedBox(height: 12),
                  // AppMainButton(
                  //   width: 200.w,
                  //   borderRadius: BorderRadius.circular(12),
                  //   onPressed: () async {
                  //     await auth.signOut();
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => const GoogleLoginScreen(),
                  //       ),
                  //     );
                  //     showSnackBar(
                  //       context,
                  //       "Signed out successfully!",
                  //       Color(AppColors.successColor),
                  //     );
                  //   },
                  //   gradient: const LinearGradient(
                  //     colors: [
                  //       Color(AppColors.blueThird),
                  //       Color(AppColors.blueLight),
                  //       Color(AppColors.secondaryColor),
                  //     ],
                  //   ),
                  //   child: const Text(
                  //     "Sign Out",
                  //     style: TextStyle(color: Color(AppColors.blackBackground)),
                  //   ),
                  // ),
                  SizedBox(height: 240.h),
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
