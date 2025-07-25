// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_images.dart';import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// List<Map<String, dynamic>> continueListeningList = [
//   // You can't use AppLocalizations.of(context)!.artist here directly because there's no BuildContext.
//   // Alternative: Pass the localized string from your widget and assign it here, or use a default value.
//   // Example with a default value:
//   {"image": "assets/image/cl/cl1.png", "name": "Artist"},
//   {"image": "assets/image/cl/cl2.png", "name": "RELEASED"},
//   {"image": "assets/image/cl/cl3.png", "name": "Anything Goes"},
//   {"image": "assets/image/cl/cl4.png", "name": "Anime OSTs"},
//   {"image": "assets/image/cl/cl5.png", "name": "Hindi Songs"},
//   {"image": "assets/image/cl/cl6.png", "name": "Lo-Fi Beats"},
// ];
// List<Map<String, dynamic>> mixSongList = [
//   {"image": "assets/image/mixsong/p1.png", "name": "Pop Mix"},
//   {"image": "assets/image/mixsong/p2.png", "name": "Chill Mix"},
//   {"image": "assets/image/mixsong/p3.png", "name": "Kpop"},
// ];

// List<Map<String, dynamic>> categorieBox = [
//   {"image": AppImages.cat1, "name": "Rock", "color": AppColors.darkGreen},
//   {"image": AppImages.cat2, "name": "Pop", "color": AppColors.darkPurple},
//   {"image": AppImages.cat3, "name": "Jazz", "color": AppColors.darkBlue},
//   {
//     "image": AppImages.cat4,
//     "name": "Hip hop",
//     "color": AppColors.darkMideumPurple,
//   },
//   {"image": AppImages.cat5, "name": "Funk", "color": AppColors.darkOrange},
//   {"image": AppImages.cat6, "name": "Dance", "color": AppColors.darkGreen},
//   {"image": AppImages.cat1, "name": "Romantic", "color": AppColors.darkPink},
//   {"image": AppImages.cat2, "name": "Lofi", "color": AppColors.darkMediumGreen},
//   {"image": AppImages.cat3, "name": "Disco", "color": AppColors.darkPurple},
//   {"image": AppImages.cat4, "name": "Sad", "color": AppColors.darkMideumPurple},
//   {
//     "image": AppImages.cat5,
//     "name": "Gospel Blues",
//     "color": AppColors.darkMediumGreen,
//   },
//   {"image": AppImages.cat1, "name": "Love", "color": AppColors.darkPink},

//   {
//     "image": AppImages.cat2,
//     "name": "Electronic",
//     "color": AppColors.darkYellow,
//   },
//   {"image": AppImages.cat3, "name": "Latin", "color": AppColors.darkBlue},
//   //--
//   {"image": AppImages.cat4, "name": "Classical", "color": AppColors.darkOrange},
//   {"image": AppImages.cat5, "name": "Ambient", "color": AppColors.darkGreen},
//   {"image": AppImages.cat6, "name": "Metal", "color": AppColors.darkPink},
//   {
//     "image": AppImages.cat1,
//     "name": "Acoustic",
//     "color": AppColors.darkMediumGreen,
//   },
//   {"image": AppImages.cat2, "name": "Reggae", "color": AppColors.darkPurple},
//   {
//     "image": AppImages.cat3,
//     "name": "Techno",
//     "color": AppColors.darkMideumPurple,
//   },
//   {"image": AppImages.cat4, "name": "Dubstep", "color": AppColors.darkPink},
//   {"image": AppImages.cat5, "name": "Chillout", "color": AppColors.darkYellow},
//   {
//     "image": AppImages.cat6,
//     "name": "Instrumental",
//     "color": AppColors.darkMideumPurple,
//   },
//   {"image": AppImages.cat1, "name": "Indie", "color": AppColors.darkOrange},
//   {"image": AppImages.cat2, "name": "World", "color": AppColors.darkGreen},
// ];
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart'; // Ensure this import exists

List<Map<String, dynamic>> continueListeningList(BuildContext context) => [
  {
    "image": "assets/image/cl/cl1.png",
    "name": AppLocalizations.of(context)!.artist,
  },
  {
    "image": "assets/image/cl/cl2.png",
    "name": AppLocalizations.of(context)!.released,
  },
  {
    "image": "assets/image/cl/cl3.png",
    "name": AppLocalizations.of(context)!.anythingGoes,
  },
  {
    "image": "assets/image/cl/cl4.png",
    "name": AppLocalizations.of(context)!.animeOSTs,
  },
  {
    "image": "assets/image/cl/cl5.png",
    "name": AppLocalizations.of(context)!.hindiSongs,
  },
  {
    "image": "assets/image/cl/cl6.png",
    "name": AppLocalizations.of(context)!.loFiBeats,
  },
];

List<Map<String, dynamic>> mixSongList(BuildContext context) => [
  {
    "image": "assets/image/mixsong/p1.png",
    "name": AppLocalizations.of(context)!.popMix,
  },
  {
    "image": "assets/image/mixsong/p2.png",
    "name": AppLocalizations.of(context)!.chillMix,
  },
  {
    "image": "assets/image/mixsong/p3.png",
    "name": AppLocalizations.of(context)!.kPop,
  },
];

List<Map<String, dynamic>> categorieBox(BuildContext context) => [
  {
    "image": AppImages.cat1,
    "name": AppLocalizations.of(context)!.rock,
    "color": AppColors.darkGreen,
  },
  {
    "image": AppImages.cat2,
    "name": AppLocalizations.of(context)!.pop,
    "color": AppColors.darkPurple,
  },
  {
    "image": AppImages.cat3,
    "name": AppLocalizations.of(context)!.jazz,
    "color": AppColors.darkBlue,
  },
  {
    "image": AppImages.cat4,
    "name": AppLocalizations.of(context)!.hiphop,
    "color": AppColors.darkMideumPurple,
  },
  {
    "image": AppImages.cat5,
    "name": AppLocalizations.of(context)!.funk,
    "color": AppColors.darkOrange,
  },
  {
    "image": AppImages.cat6,
    "name": AppLocalizations.of(context)!.dance,
    "color": AppColors.darkGreen,
  },
  {
    "image": AppImages.cat1,
    "name": AppLocalizations.of(context)!.romantic,
    "color": AppColors.darkPink,
  },
  {
    "image": AppImages.cat2,
    "name": AppLocalizations.of(context)!.lofi,
    "color": AppColors.darkMediumGreen,
  },
  {
    "image": AppImages.cat3,
    "name": AppLocalizations.of(context)!.disco,
    "color": AppColors.darkPurple,
  },
  {
    "image": AppImages.cat4,
    "name": AppLocalizations.of(context)!.sad,
    "color": AppColors.darkMideumPurple,
  },
  {
    "image": AppImages.cat5,
    "name": AppLocalizations.of(context)!.gospelBlues,
    "color": AppColors.darkMediumGreen,
  },
  {
    "image": AppImages.cat1,
    "name": AppLocalizations.of(context)!.love,
    "color": AppColors.darkPink,
  },
  {
    "image": AppImages.cat2,
    "name": AppLocalizations.of(context)!.electronic,
    "color": AppColors.darkYellow,
  },
  {
    "image": AppImages.cat3,
    "name": AppLocalizations.of(context)!.latin,
    "color": AppColors.darkBlue,
  },
  {
    "image": AppImages.cat4,
    "name": AppLocalizations.of(context)!.classical,
    "color": AppColors.darkOrange,
  },
  {
    "image": AppImages.cat5,
    "name": AppLocalizations.of(context)!.ambient,
    "color": AppColors.darkGreen,
  },
  {
    "image": AppImages.cat6,
    "name": AppLocalizations.of(context)!.metal,
    "color": AppColors.darkPink,
  },
  {
    "image": AppImages.cat1,
    "name": AppLocalizations.of(context)!.acoustic,
    "color": AppColors.darkMediumGreen,
  },
  {
    "image": AppImages.cat2,
    "name": AppLocalizations.of(context)!.reggae,
    "color": AppColors.darkPurple,
  },
  {
    "image": AppImages.cat3,
    "name": AppLocalizations.of(context)!.techno,
    "color": AppColors.darkMideumPurple,
  },
  {
    "image": AppImages.cat4,
    "name": AppLocalizations.of(context)!.dubstep,
    "color": AppColors.darkPink,
  },
  {
    "image": AppImages.cat5,
    "name": AppLocalizations.of(context)!.chillout,
    "color": AppColors.darkYellow,
  },
  {
    "image": AppImages.cat6,
    "name": AppLocalizations.of(context)!.instrumental,
    "color": AppColors.darkMideumPurple,
  },
  {
    "image": AppImages.cat1,
    "name": AppLocalizations.of(context)!.indie,
    "color": AppColors.darkOrange,
  },
  {
    "image": AppImages.cat2,
    "name": AppLocalizations.of(context)!.world,
    "color": AppColors.darkGreen,
  },
];
