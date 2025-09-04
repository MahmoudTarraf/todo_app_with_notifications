import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/controller/my_account_controller.dart';

import '../../core/const_data/app_colors.dart';
import '../../core/const_data/text_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final thisUser = Get.find<UserService>().currentUser;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 🧑 User Profile
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: ColorsManager.white.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: AssetImage(AppImages.goku),
                  ),
                  SizedBox(width: 20.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thisUser!.name.toString(),
                          style: TextStyles.headingTextStyle(context)
                              .copyWith(fontSize: 20.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          thisUser.email.toString(),
                          style: TextStyles.smallTextStyle(context).copyWith(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // 📋 Drawer Options
            _buildDrawerTile(
              icon: Icons.person_outline,
              title: "My Account".tr,
              onTap: () {
                Get.back();
                Get.toNamed(Routes.myAccountScreen);
              },
            ),
            _buildDrawerTile(
              icon: Icons.emoji_events_outlined,
              title: "My Achievements".tr,
              onTap: () {
                Get.toNamed(Routes.achievementsScreen);
              },
            ),
            _buildDrawerTile(
              icon: Icons.settings_outlined,
              title: "settings".tr,
              onTap: () {
                Get.toNamed(Routes.settingsSreen);
              },
            ),
            _buildDrawerTile(
              icon: Icons.info_outline,
              title: "About App".tr,
              onTap: () {
                Get.toNamed(Routes.aboutAppWidget);
              },
            ),

            const Spacer(),

            // 🚪 Logout Button
            Obx(() {
              final controller = Get.put(MyAccountController());

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white, // automatically switches
                    minimumSize: Size.fromHeight(60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: controller.isLoader.value
                      ? const SizedBox()
                      : Icon(
                          Icons.logout,
                          size: 25.r,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white, // dynamic icon color
                        ),
                  label: controller.isLoader.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                  onPressed: () async {
                    await controller.logout();
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Builder(builder: (context) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 30.r,
        ),
        title: Text(title, style: TextStyles.bodyTextStyle(context)),
        onTap: onTap,
      );
    });
  }
}
