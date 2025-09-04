import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextDirectionHelper {
  static TextDirection get currentDirection {
    return (Get.locale?.languageCode == 'ar')
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
