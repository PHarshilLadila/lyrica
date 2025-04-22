// import 'package:flutter/material.dart';
// import 'package:lyrica/common/widget/app_main_button.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/modules/auth/view/google_login_screen.dart';

// class LibraryScreen extends ConsumerStatefulWidget {
//   const LibraryScreen({super.key});

//   @override
//   State<LibraryScreen> createState() => _LibraryScreenState();
// }

// class _LibraryScreenState extends State<LibraryScreen> {
//   @override
//   Widget build(BuildContext context) {
//         final auth = ref.read(authControllerProvider);

//     return Scaffold(
//       backgroundColor: const Color(AppColors.blackBackground),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Center(child: Text("library", style: TextStyle(color: Colors.white),),),
//           AppMainButton(
//             borderRadius: BorderRadius.circular(12),
//             onPressed: () async {
//               await auth.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
//               );
//             },
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(AppColors.blueThird),
//                 Color(AppColors.blueLight),
//                 Color(AppColors.secondaryColor),
//               ],
//             ),
//             child: const Text(
//               "Sign Out",
//               style: TextStyle(color: Color(AppColors.blackBackground)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);

    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text("User not found"));

        return Scaffold(
          backgroundColor: const Color(AppColors.blackBackground),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text("library", style: TextStyle(color: Colors.white)),
              ),
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
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Color(AppColors.blackBackground)),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: appLoader( )),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
