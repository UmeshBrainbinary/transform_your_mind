import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/model_class/faq_model.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';

class SupportController extends GetxController {
  RxList supportData = [].obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController comment = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode commentFocus = FocusNode();
  RxList<FaqData>? faqList = <FaqData>[].obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    supportData.value = _SupportData.getSettingsData;
    super.onInit();
  }

  List<bool> faq = [];

  getFaqList() {
    final profileController = Get.find<ProfileController>();
    faqList!.value = profileController.faqData!;
    List.generate(
      faqList!.length,
      (index) => faq.add(false),
    );
    update();
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
