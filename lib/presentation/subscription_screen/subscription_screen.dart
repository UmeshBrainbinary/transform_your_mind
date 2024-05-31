import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class SubscriptionScreen extends StatelessWidget {
   SubscriptionScreen({super.key});

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const AddGratitudePage(
            registerUser: true,
            isFromMyGratitude: true,
            isSaved: true,);
        },));
      },
        child: Center(
          child:   Text("Skip", style:Style.montserratRegular(
            fontSize: Dimens.d15,
            color: themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black,
          ),)
        ),
      ),
    );
  }
}
