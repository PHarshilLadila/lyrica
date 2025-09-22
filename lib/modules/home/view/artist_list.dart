import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/home/view/artist_details.dart';

final artistSearchProvider = StateProvider<String>((ref) => '');

class ArtistList extends ConsumerStatefulWidget {
  const ArtistList({super.key});

  @override
  ConsumerState<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends ConsumerState<ArtistList> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artisAsync = ref.watch(artistDataProvider);
    final searchText = ref.watch(artistSearchProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Atrists",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        body: artisAsync.when(
          data: (artist) {
            final filteredArtist =
                searchText.trim().isEmpty
                    ? artist
                    : artist.where((a) {
                      final name = a.name?.toLowerCase() ?? '';
                      return name.contains(searchText.toLowerCase());
                    }).toList();

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        ref.read(artistSearchProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Search artist...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: filteredArtist.length,
                      itemBuilder: (context, index) {
                        final data = filteredArtist[index];
                        String? imageUrl = data.image;
                        if (imageUrl == "") {
                          imageUrl = AppString.defaultImageLogo;
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
                                borderRadius: BorderRadius.circular(12.sp),
                                child: Image.network(
                                  imageUrl ?? AppString.defaultImageLogo,
                                  fit: BoxFit.cover,
                                  height: 80.h,
                                  width: 90.w,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              AppText(
                                fontSize: 16.sp,
                                text: data.name ?? "",
                                textColor: Color(AppColors.lightText),
                              ),
                              AppText(
                                fontSize: 12.sp,
                                text: data.joindate ?? "",
                                textColor: Color(AppColors.lightText),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
