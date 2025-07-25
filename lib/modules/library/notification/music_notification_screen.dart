import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/modules/library/notification/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MusicReminderScreen extends StatelessWidget {
  const MusicReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AppText(
            text: AppLocalizations.of(context)!.notification,
            textColor: Color(AppColors.whiteBackground),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          leading: AppBackButton(),
        ),
        body: ChangeNotifierProvider(
          create: (_) => MusicNotificationProvider()..init(),
          child: Consumer<MusicNotificationProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: [_buildEnableNotificationSwitch(provider, context)],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEnableNotificationSwitch(
    MusicNotificationProvider provider,
    BuildContext context,
  ) {
    return Card(
      color: Color(AppColors.whiteBackground).withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: AppLocalizations.of(context)!.enableNotification,
              fontWeight: FontWeight.w500,
              textColor: Color(AppColors.whiteBackground),

              fontSize: 16.sp,
            ),
            CupertinoSwitch(
              inactiveThumbColor: Color(AppColors.primaryColor),
              inactiveTrackColor: Color(AppColors.whiteBackground),
              value: provider.notificationsEnabled,
              onChanged: provider.toggleNotifications,
              activeColor: Color(AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
