// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/l10n/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLanguagesScreen extends StatelessWidget {
  const AppLanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale?.toString() ?? 'en';

    return ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),

      child: Container(
        decoration: BoxDecoration(gradient: backgroundGradient()),

        child: Scaffold(
          backgroundColor: const Color.fromARGB(197, 0, 43, 53),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: AppBackButton(),
            title: AppText(
              fontWeight: FontWeight.bold,
              text: AppLocalizations.of(context)!.language,
              textColor: Color(AppColors.whiteBackground),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  color: Color(AppColors.whiteBackground).withOpacity(0.2),
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.selectedLanguage,
                          fontWeight: FontWeight.w500,
                          textColor: Color(AppColors.whiteBackground),
                          maxLines: 2,
                          fontSize: 16.sp,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButton<String>(
                            elevation: 6,
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            value: currentLocale,
                            onChanged: (String? newLangCode) {
                              if (newLangCode != null) {
                                if (newLangCode.contains('_')) {
                                  final parts = newLangCode.split('_');
                                  localeProvider.setLocale(
                                    Locale(parts[0], parts[1]),
                                  );
                                } else {
                                  localeProvider.setLocale(Locale(newLangCode));
                                }
                              }
                            },

                            items: const [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(
                                  'English',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'hi',
                                child: Text(
                                  'हिन्दी',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'gu',
                                child: Text(
                                  'ગુજરાતી',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'es',
                                child: Text(
                                  'Español',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'de',
                                child: Text(
                                  'Deutschland',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'fr',
                                child: Text(
                                  'Français',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'pt',
                                child: Text(
                                  'Português',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'ru',
                                child: Text(
                                  'Russkiy',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'zh',
                                child: Text(
                                  'Zhōngwén',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'ko',
                                child: Text(
                                  'Hangug-eo',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'ar_EG',
                                child: Text(
                                  'مصر العربية',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
