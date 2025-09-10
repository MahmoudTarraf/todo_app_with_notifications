import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/widgets/custom_app_bar.dart';

import '../core/const_data/text_styles.dart';
import '../core/utils/text_direction_helper.dart';

class AboutAppWidget extends StatelessWidget {
  const AboutAppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About App'.tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rowBuilder('Version :'.tr, "1.0.0"),
                      questionAnswer(
                        'What is Tasker?'.tr,
                        'taskerDes'.tr,
                      ),
                      questionAnswer(
                        'Why Tasker?'.tr,
                        'taskerRes'.tr,
                      ),
                      questionAnswer(
                        'How does it work?'.tr,
                        'taskerHow'.tr,
                      ),
                      questionAnswer(
                        'What’s Next?'.tr,
                        'taskerNext'.tr,
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget rowBuilder(
  String name,
  String value,
) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20.h),
    child: Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            textDirection: TextDirectionHelper.currentDirection,
            name,
            style: TextStyles.bodyTextStyle(context),
          ),
          Text(
            textDirection: TextDirectionHelper.currentDirection,
            value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ],
      );
    }),
  );
}

Widget questionAnswer(String question, String answer) {
  return Builder(builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 10.h,
          ),
          child: Center(
            child: Text(
              textDirection: TextDirectionHelper.currentDirection,
              question,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            textDirection: TextDirectionHelper.currentDirection,
            answer,
            style: TextStyles.bodyTextStyle(context),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  });
}
