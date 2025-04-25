// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(153, 167, 251, 255).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AppText(
                                textName: "Website Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                    widget.website ?? "",
                                  );
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.website ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  textName:
                                      widget.website ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: AppText(
                                textName: "Short Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(widget.short ?? "");
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.short ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  textName:
                                      widget.short ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: AppText(
                                textName: "Share Url ",
                                fontSize: 14.sp,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(widget.share ?? "");
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                      'Could not launch ${widget.share ?? ""}',
                                    );
                                  }
                                },
                                child: AppText(
                                  textName:
                                      widget.share ??
                                      "No description available.",
                                  fontSize: 14.sp,
                                  textColor: Color(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                AppText(
                  textName: "${widget.name}' Songs",
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
                        physics: NeverScrollableScrollPhysics(),
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
                    return Text("Something went to wrong..!");
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
      ),
    );
  }
}
