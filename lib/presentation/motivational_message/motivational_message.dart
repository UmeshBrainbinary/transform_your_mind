import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class MotivationalMessageScreen extends StatefulWidget {
  const MotivationalMessageScreen({super.key});

  @override
  State<MotivationalMessageScreen> createState() => _MotivationalMessageScreenState();
}

class _MotivationalMessageScreenState extends State<MotivationalMessageScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  MotivationalController motivationalController =
  Get.put(MotivationalController());
  @override
  Widget build(BuildContext context) {

    statusBarSet(themeController);


    return Stack(
      children: [
        SafeArea(bottom: false,
          child: Scaffold(
            appBar: CustomAppBar(
              title: "motivationalMessages".tr,
              showBack: true,
            ),
            backgroundColor: themeController.isDarkMode.value
                ? ColorConstant.darkBackground
                : ColorConstant.backGround,
            body: SingleChildScrollView(
              // motivational
              child: Column(
                children: [
                  Dimens.d31.spaceHeight,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GetBuilder<MotivationalController>(
                      id: "motivational",
                      builder: (controller) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.motivationalList.length,
                          itemBuilder: (context, index) {
                            var data =
                            controller.motivationalList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        data["img"]),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 30),
                                child: Stack(
                                  children: [
                                    Text(
                                      data["title"],
                                      textAlign: TextAlign.center,
                                      style: Style.cormorantGaramondBold(
                                          fontSize: 20, color: ColorConstant.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Obx(() => motivationalController.loader.isTrue?commonLoader():const SizedBox(),)
      ],
    );
  }
}
