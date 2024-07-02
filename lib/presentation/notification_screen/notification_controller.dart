import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class NotificationController extends GetxController{
  RxList notificationList = [
    {"title":"transform Yor Mind","des":"hi buddy we are with you don't loose hope every day is not same day."},
    {"title":"transform Yor Mind","des":"hi buddy we are with you don't loose hope every day is not same day."},
    {"title":"transform Yor Mind","des":"hi buddy we are with you don't loose hope every day is not same day."},
  ].obs;

  @override
  void onInit() {

    super.onInit();
  }
}