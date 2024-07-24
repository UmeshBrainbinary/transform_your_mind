import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List favList = [
    {
      "title": "Self-esteem",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Health",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Success",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Health",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Self-esteem",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
  ];
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground: ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "Favourite".tr,
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: favList.length,
            itemBuilder: (context, index) {
              return  Container(height: 97,
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:ColorConstant.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          favList[index]["title"],
                          style: Style.nunRegular(fontSize: 18),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              favList.removeAt(index);
                              setState(() {});
                            },
                            child: SvgPicture.asset(
                              ImageConstant.likeRedTools,
                              height: 16.5,
                              width: 16.5,
                            )),
                        Dimens.d12.spaceWidth,
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(maxLines: 2,
                        favList[index]["des"],
                        style: Style.nunRegular(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
