// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/list_helper.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/home/view/artist_list.dart';
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
  }

  Future<void> checkDeviceConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => "Internet Checking..");
    switch (result as ConnectivityResult) {
      case ConnectivityResult.mobile:
        setState(() {
          showSnackBar(context, "Connected to mobile network");
        });
        break;

      case ConnectivityResult.bluetooth:
        setState(() {
          showSnackBar(context, "Connected to mobile bluetooth");
        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          showSnackBar(context, "Connected to mobile wifi");
        });
        break;
      case ConnectivityResult.ethernet:
        setState(() {
          showSnackBar(context, "Connected to mobile ethernet");
        });
        break;
      case ConnectivityResult.none:
        showSnackBar(context, "Please Connect with your Internet..!");
        break;
      case ConnectivityResult.vpn:
        debugPrint("Connected to mobile vpn");
        break;
      case ConnectivityResult.other:
        setState(() {
          showSnackBar(context, "");
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);
    final userAsync = ref.watch(authStateProvider);
    final userModelAsync = ref.watch(userModelProvider);
    // final musicAsyncValue = ref.watch(musicDataProvider);
    final artisAsync = ref.watch(artistDataProvider);

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
                      if (userModel == null) {
                        return Text(
                          user.displayName?[0] ?? "",
                          style: GoogleFonts.poppins(
                            color: Color(AppColors.lightText),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        user.displayName ?? userModel.username[0],
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
                          user.displayName ?? "",
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
                      Text(
                        "Continue Listening",
                        style: GoogleFonts.poppins(
                          color: Color(AppColors.lightText),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3.5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: continueListeningList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      topLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      "${continueListeningList[index]['image']}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  "${continueListeningList[index]['name']}",
                                  style: GoogleFonts.poppins(
                                    color: Color(AppColors.lightText),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
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
                                        textName: artist[index].joindate ?? "",
                                        textColor: Color(AppColors.lightText),
                                      ),
                                    ],
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
                      SizedBox(height: 20.h),
                      AppMainButton(
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () async {
                          await auth.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GoogleLoginScreen(),
                            ),
                          );
                        },
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(AppColors.blueThird),
                            Color(AppColors.blueLight),
                            Color(AppColors.secondaryColor),
                          ],
                        ),
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Color(AppColors.blackBackground),
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),
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
