import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/home/view/artist_details.dart';

class ArtistList extends ConsumerStatefulWidget {
  const ArtistList({super.key});

  @override
  ConsumerState<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends ConsumerState<ArtistList> {
  @override
  Widget build(BuildContext context) {
    final artisAsync = ref.watch(artistDataProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 39, 39, 39),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                textName: "Atrists",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        body: artisAsync.when(
          data: (artist) {
            return SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.6,
                ),
                itemCount: artist.length,
                itemBuilder: (context, index) {
                  final data = artist[index];
                  String? imageUrl = artist[index].image;
                  if (artist[index].image == "") {
                    imageUrl =
                        "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
                  } else {
                    imageUrl = artist[index].image;
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ArtistDetails(
                                id: data.id,
                                name: data.name ?? "",
                                date: data.joindate,
                                website: data.website,
                                share: data.shareurl,
                                short: data.shorturl,
                                image: imageUrl,
                              ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
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
                          fontSize: 16.sp,
                          textName: artist[index].name ?? "",
                          textColor: Color(AppColors.lightText),
                        ),
                        AppText(
                          fontSize: 12.sp,
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
          loading: () => Center(child: appLoader()),
          error:
              (e, _) => Center(
                child: Text(
                  "Error loading artists",
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
