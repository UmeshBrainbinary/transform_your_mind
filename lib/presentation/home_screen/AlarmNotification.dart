import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class AlarmNotificationScreen extends StatefulWidget {
  AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageConstant.transformNLogo,
            height: 127,
            width: 127,
          ),
          Dimens.d20.spaceHeight,
          Text(
            "TransformYourMind",
            style: Style.nunRegular(fontSize: 20),
          ),
          Dimens.d10.spaceHeight,
          Text(
            "Alram is ringing".tr,
            style: Style.nunRegular(fontSize: 15),
          ),
          Dimens.d45.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130),
            child: CommonElevatedButton(
              height: 38,
              textStyle: Style.nunRegular(fontSize: 14,color: Colors.white),
              title: "Stop".tr,
              onTap: () {
                Alarm.stop(widget.alarmSettings.id)
                    .then((_) => Navigator.pop(context));
              },
            ),
          ),
        ],
      ),
    );
  }
}
