//  Text(
//                         "Continue Listening",
//                         style: GoogleFonts.poppins(
//                           color: Color(AppColors.lightText),
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 3.5,
//                               crossAxisSpacing: 8,
//                               mainAxisSpacing: 8,
//                             ),
//                         itemCount: continueListeningList.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => MusicTrackList(
//                                         "All",
//                                         musicType: 1,
//                                         genre: '',
//                                       ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white12,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 50.w,
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(12),
//                                         topLeft: Radius.circular(12),
//                                       ),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(5),
//                                       child: Image.asset(
//                                         "${continueListeningList[index]['image']}",
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 15.w),
//                                   Text(
//                                     "${continueListeningList[index]['name']}",
//                                     style: GoogleFonts.poppins(
//                                       color: Color(AppColors.lightText),
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),