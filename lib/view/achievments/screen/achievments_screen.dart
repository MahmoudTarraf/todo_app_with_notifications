import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const_data/app_images.dart';
import '../../../core/const_data/text_styles.dart';
import '../controller/achievments_controller.dart';
import 'achievments_card.dart';

class AchievmentsScreen extends StatelessWidget {
  const AchievmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achController = Get.put(AchievementsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Achievements'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Obx(() {
          final list = achController.achievementsList;
          if (list.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: SizedBox(
                      height: 200.h,
                      child: Image.asset(
                        AppImages.achievements,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "No_Achievements".tr,
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              AchievmentsCard(
                achievments: list,
              ),
            ],
          );
        }),
      ),
    );
  }
}
