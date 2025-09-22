// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';

import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/in%20app%20purchase/view/in_app_purchase.dart';
import 'package:lyrica/modules/library/languages/app_language.dart';
import 'package:lyrica/modules/library/music_equalizer/music_equalizer_screen.dart';
import 'package:lyrica/modules/library/notification/music_notification_screen.dart';
import 'package:lyrica/modules/library/service/ad_mob_service.dart';
import 'package:lyrica/modules/music%20player/view/favorite_music_screen.dart';

import 'package:lyrica/modules/playlist/widget/playlist_bottomsheet.dart';
import 'package:lyrica/modules/profile/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          showAppSnackBar(
            context,
            '🎉 ${AppLocalizations.of(context)!.youEarnedTwoPoints}',
            Color(AppColors.successColor),
          );
        },
      );
      _rewardedAd = null;
    } else {
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.rewardADNotReady,
        Colors.red,
      );
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

  void modalBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 350.0,
          color: Colors.transparent,

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: InApp(),
          ),
        );
      },
    );
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
        if (user == null) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromARGB(255, 0, 33, 43),
            child: Center(child: appLoader()),
          );
        }

        return Container(
          decoration: BoxDecoration(gradient: backgroundGradient()),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(197, 0, 43, 53),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90,
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 8,
                  bottom: 8,
                  top: 8,
                ),
                child: Image.asset(AppImages.logoWithoutBG),
              ),
              title: AppText(
                text: AppLocalizations.of(context)!.yourLibraries,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
                textColor: Color(AppColors.lightText),
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
                  ),
                ),
                IconButton(
                  icon: Image.asset(AppImages.settingIcon, width: 25.w),
                  onPressed: () => _showInterstitialAd(),
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
                    showAppSnackBar(
                      context,
                      AppLocalizations.of(context)!.signOutSuccess,
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
                      padding: EdgeInsets.only(top: 16.h),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
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
                                        AppText(
                                          maxLines: 2,
                                          text:
                                              "${AppLocalizations.of(context)!.hey} $userLocalName,",
                                          fontSize: 26,
                                          textColor: Color(
                                            AppColors.whiteBackground,
                                          ).withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(height: 8),
                                        AppText(
                                          maxLines: 2,
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.doYouKnowAboutReward,
                                          fontSize: 18,
                                          textColor: Color(
                                            AppColors.whiteBackground,
                                          ).withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 18),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(
                                              AppColors.primaryColor,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed: _showRewardedAd,
                                          icon: Icon(
                                            Icons.card_giftcard,
                                            color: Colors.white,
                                          ),
                                          label: AppText(
                                            text:
                                                AppLocalizations.of(
                                                  context,
                                                )!.earnNow,
                                            fontWeight: FontWeight.bold,
                                            textColor: Colors.white,
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                              bottom: 10.h,
                              left: 115.w,

                              child: Container(
                                height: 35.h,
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
                                    AppText(
                                      text:
                                          "$points ${AppLocalizations.of(context)!.points}",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          loading: () => Center(child: appLoader()),
                          error: (e, _) => SizedBox.shrink(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(106, 29, 178, 183),
                            Color.fromARGB(255, 13, 164, 184),
                            Color.fromARGB(106, 23, 106, 109),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildAttractiveTile(
                            icon: Icons.person_2,
                            title: AppLocalizations.of(context)!.profile,
                            subtitle:
                                AppLocalizations.of(context)!.profileSubTitle,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8.h),

                          _buildAttractiveTile(
                            icon: Icons.music_note,
                            title: AppLocalizations.of(context)!.playList,
                            subtitle:
                                AppLocalizations.of(context)!.playListSubTitle,
                            onTap: () {
                              showPlaylistOptionsSheet(context);
                            },
                          ),
                          SizedBox(height: 8.h),
                          _buildAttractiveTile(
                            icon: Icons.notifications,
                            title: AppLocalizations.of(context)!.notification,
                            subtitle:
                                AppLocalizations.of(
                                  context,
                                )!.notificationSubTitle,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicReminderScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          _buildAttractiveTile(
                            icon: Icons.translate,
                            title: AppLocalizations.of(context)!.language,
                            subtitle:
                                AppLocalizations.of(context)!.languageSubTitle,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppLanguagesScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          _buildAttractiveTile(
                            icon: Icons.equalizer,

                            // title: AppLocalizations.of(context)!.language,
                            title: "Music Equalizer",
                            subtitle:
                                "The ultimate tone control to make music sound perfect—for you.",
                            // AppLocalizations.of(context)!.languageSubTitle,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicEqualizerScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          _buildAttractiveTile(
                            icon: Icons.star,
                            title:
                                AppLocalizations.of(context)!.buySubscription,
                            subtitle:
                                AppLocalizations.of(
                                  context,
                                )!.buySubscriptionSubTitle,
                            onTap: () {
                              modalBottomSheetMenu();
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 80.h),
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
          ),
        );
      },
      loading: () => Center(child: appLoader()),
      error: (e, _) => Center(child: AppText(text: "Error: $e")),
    );
  }

  Widget _buildAttractiveTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12.sp),
      color: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.sp),
        onTap: onTap,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white),
          ),
          title: AppText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            textColor: Color(AppColors.whiteBackground),
          ),
          subtitle:
              subtitle != null
                  ? AppText(
                    text: subtitle,
                    fontSize: 12.sp,
                    textColor: Color(
                      AppColors.whiteBackground,
                    ).withOpacity(0.8),
                  )
                  : null,
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
