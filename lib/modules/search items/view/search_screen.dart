import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/list_helper.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/music%20track/view/music_track_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);

    // final rockMusic = ref.watch(rockMusicDataProvider());
    return Container(
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
            "Explore Categories",
            style: GoogleFonts.poppins(
              color: Color(AppColors.lightText),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
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
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  var mainColor = int.parse("${categorieBox[index]["color"]}");
                  return GestureDetector(
                    onTap: () {
                      // String selectedGenre = categorieBox[index]['pop'];
                      if (index == 0) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=rock&limit=50",
                          ),
                        );
                      } else if (index == 1) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=pop&limit=50",
                          ),
                        );
                      } else if (index == 2) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=jazz&limit=50",
                          ),
                        );
                      } else if (index == 3) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=hiphop&limit=50",
                          ),
                        );
                      } else if (index == 4) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=funk&limit=50",
                          ),
                        );
                      } else if (index == 5) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=dance",
                          ),
                        );
                      } else if (index == 6) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=romantic&limit=50",
                          ),
                        );
                      } else if (index == 7) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=lofi&limit=50",
                          ),
                        );
                      } else if (index == 8) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=disco&limit=50",
                          ),
                        );
                      } else if (index == 9) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=sad&limit=50",
                          ),
                        );
                      } else if (index == 10) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=gospel&limit=50",
                          ),
                        );
                      } else if (index == 11) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=love&limit=50",
                          ),
                        );
                      } else if (index == 12) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=electronic&limit=50",
                          ),
                        );
                      } else if (index == 13) {
                        myPushNavigator(
                          context,
                          MusicTrackList(
                            "${categorieBox[index]['name']}",
                            musicType: -1,
                            genre: "format=json&tags=latin&limit=50",
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
                            padding: const EdgeInsets.only(left: 15.0, top: 15),
                            child: AppText(
                              textName: "${categorieBox[index]['name']}",
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
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
