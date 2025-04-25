// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';

class ArtistDetails extends ConsumerStatefulWidget {
  final String? id;
  final String? name;
  final String? date;
  final String? website;
  final String? short;
  final String? share;
  final String? image;

  const ArtistDetails({
    super.key,
    this.name,
    this.date,
    this.website,
    this.short,
    this.share,
    this.image,
    this.id,
  });

  @override
  ConsumerState<ArtistDetails> createState() => _ArtistDetailsState();
}

class _ArtistDetailsState extends ConsumerState<ArtistDetails> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double showoffset = 5.0;

      if (scrollController.offset > showoffset) {
        if (!showbtn) {
          setState(() {
            showbtn = true;
          });
        }
      } else {
        if (showbtn) {
          setState(() {
            showbtn = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artistMusicDataProviderSync = ref.watch(
      artistMusicDataProvider(widget.id ?? ""),
    );

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 39, 39, 39),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: AppText(
            textName: widget.name ?? "",
            fontSize: 20.sp,
            textColor: Color(AppColors.lightText),
            fontWeight: FontWeight.w500,
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.image ??
                          "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                    textName: widget.name ?? "Unknown Artist",
                    fontSize: 24.sp,
                    textColor: Color(AppColors.lightText),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                    textName: "From : ${widget.date ?? "N/A"}",
                    fontSize: 16.sp,
                    textColor: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),

                // Artist Songs Section
                AppText(
                  textName: "${widget.name}'s Songs",
                  fontSize: 20.sp,
                  textColor: Color(AppColors.lightText),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),

                artistMusicDataProviderSync.when(
                  data: (artistDetails) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          153,
                          167,
                          251,
                          255,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: artistDetails.length,
                        itemBuilder: (context, index) {
                          final song = artistDetails[index];
                          return GestureDetector(
                            onTap: () {
                              myPushNavigator(
                                context,
                                MusicPlayer(
                                  songList: artistDetails,
                                  initialIndex: index,
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.black12,
                              elevation: 0,
                              child: ListTile(
                                trailing: FaIcon(
                                  FontAwesomeIcons.circlePlay,
                                  color: Color(AppColors.blueLight),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(AppColors.blueLight),
                                      offset: Offset(1, 5),
                                      blurRadius: 30,
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    song.image ??
                                        "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                                    width: 50.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: AppText(
                                  textName: song.name ?? "Unknown Song",
                                  fontSize: 16.sp,
                                  textColor: Color(AppColors.lightText),
                                ),
                                subtitle: AppText(
                                  textName: song.albumName ?? "N/A",
                                  fontSize: 12.sp,
                                  textColor: Colors.white54,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return const Center(child: Text("Something went wrong!"));
                  },
                  loading: () {
                    return Center(child: appLoader());
                  },
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedOpacity(
          opacity: showbtn ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 23, 106, 109),
                    Color.fromARGB(255, 29, 178, 183),
                    Color.fromARGB(255, 29, 178, 183),
                    Color.fromARGB(255, 23, 106, 109),
                  ],
                ),
                border: Border.all(color: Colors.white54, width: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.arrowUpLong,
                    color: Color(AppColors.whiteBackground),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
