import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class SupportController extends GetxController {
  RxList supportData = [].obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController comment = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode commentFocus = FocusNode();
  RxList faqList = [
    {
      "title": "What is App Name?",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
    {
      "title": "How to use App Name?",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
    {
      "title": "How do i delete Affirmations Alarms? ",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
    {
      "title": "How to use App?",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
    {
      "title": "How to add Affirmations Alarms ?",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
    {
      "title": "How to add Gratitude",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    },
  ].obs;
  RxList contactSupport = [
    {"title": "Customer Service", "img": "assets/icons/headphones.svg"},
    {"title": "WhatsApp", "img": "assets/icons/whatsapp.svg"},
    {"title": "Website", "img": "assets/icons/web.svg"},
    {"title": "Facebook", "img": "assets/icons/facebook.svg"},
    {"title": "Twitter", "img": "assets/icons/twitter.svg"},
    {"title": "Instagram", "img": "assets/icons/instagram.svg"},
  ].obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    supportData.value = _SupportData.getSettingsData;
    super.onInit();
  }
}

class _SupportData {
  final String prefixIcon;
  final String title;
  final String suffixIcon;
  final int index;

  _SupportData({
    required this.prefixIcon,
    required this.title,
    required this.suffixIcon,
    required this.index,
  });

  static get getSettingsData => [
        _SupportData(
          prefixIcon: ImageConstant.settingArrowRight,
          title: "FAQ",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 0,
        ),
        _SupportData(
          prefixIcon: ImageConstant.settingsSubscription,
          title: "contactSupport",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 1,
        ),
        _SupportData(
          prefixIcon: ImageConstant.settingsAccount,
          title: "troubleshootingGuides",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 2,
        ),
      ];
}
