import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

Widget commonLoader() {
  return GestureDetector(
      onTap: () {},
      child: Container(
          color: Colors.transparent,
          height: Get.height,
          width: Get.width,
          child: const Center(
            child: CircularProgressIndicator(
              color: ColorConstant.themeColor,
            ),
          )));
}
