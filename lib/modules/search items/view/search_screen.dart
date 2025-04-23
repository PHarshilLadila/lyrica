import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/list_helper.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
// import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/music%20track/view/music_track_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    // final rockMusic = ref.watch(rockMusicDataProvider());
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 39, 39, 39),
        appBar: AppBar(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              textColor: Color(AppColors.lightText),
              textName: "Your Top Genres",
              fontSize: 20.sp,
              fontWidth: FontWeight.bold,
            ),
            SizedBox(height: 15.h),
            GridView.builder(
              shrinkWrap: true,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=rock",
                              ),
                        ),
                      );
                    } else if(index == 1){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=pop",
                              ),
                        ),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=jazz",
                              ),
                        ),
                      );
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=hiphop",
                              ),
                        ),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=funk",
                              ),
                        ),
                      );
                    } else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicTrackList(
                                musicType: -1,
                                genre: "format=json&tags=dance",
                              ),
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
                            fontWidth: FontWeight.bold,
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
    );
  }
}
