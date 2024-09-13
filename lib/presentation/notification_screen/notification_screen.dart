import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/notification_screen/notification_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    NotificationController notificationController =
        Get.put(NotificationController());
    return Scaffold(backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
      appBar: CustomAppBar(title: "notifications".tr),
      body: Column(
        children: [
          Dimens.d30.spaceHeight,
          Expanded(
            child: ListView.separated(
              itemCount: notificationController.notificationList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var data = notificationController.notificationList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageConstant.splashLogo,
                        height: 50,
                        width: 50,
                      ),
                      Dimens.d20.spaceWidth,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["title"],
                            style: Style.cormorantGaramondBold(fontSize: 16),
                          ),
                          SizedBox(
                            width: Get.width - 120,
                            child: Text(
                              data["des"],
                              style: Style.nunRegular(fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: ColorConstant.backGround,
                // Customize the color as needed
                thickness: 3,
                // Customize the thickness as needed
                indent: 20,
                // Customize the indent as needed
                endIndent: 20, // Customize the end indent as needed
              ),
            ),
          )
        ],
      ),
    );
  }
}
