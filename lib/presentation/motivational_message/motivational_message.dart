import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class MotivationalMessageScreen extends StatelessWidget {
  const MotivationalMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    MotivationalController motivationalController =
        Get.put(MotivationalController());
    return Scaffold(
      appBar: CustomAppBar(
        title: "motivationalMessages".tr,
        showBack: true,
      ),
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.black
          : ColorConstant.backGround,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Dimens.d31.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: motivationalController.motivationalList.length,
                  itemBuilder: (context, index) {
                    var data = motivationalController.motivationalList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                         // Image.asset(data["img"],fit: BoxFit.cover,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                            child: Text(data["title"],style: Style.cormorantGaramondBold(fontSize: 20),),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}