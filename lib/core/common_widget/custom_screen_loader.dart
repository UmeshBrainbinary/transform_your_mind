import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

Widget commonLoader() {

  return  Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(0),
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(35),
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow:  [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: const CircularProgressIndicator(
          backgroundColor: ColorConstant.black,
          color:ColorConstant.themeColor,
        ),
      ),
    ),
  );
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
