import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.black
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "Alarm".tr,
        showBack: true,

      ),
      body: Column(children: [
        Dimens.d10.spaceHeight,
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: affirmationList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          "9:30",
                          style: Style.montserratRegular(
                            fontSize: 30,
                          ),
                        ), Text(
                          " PM",
                          style: Style.montserratRegular(
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddAffirmationPage(
                                  isEdit: true,
                                  title: affirmationList[index]["title"],
                                  des: affirmationList[index]["des"],
                                  isFromMyAffirmation: true,
                                );
                              },
                            ));
                          },
                          child: SvgPicture.asset(
                            ImageConstant.editTools,
                            height: 18,
                            width: 18,
                            color: ColorConstant.black,
                          ),
                        ),
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            affirmationList.removeAt(index);
                            setState(() {

                            });
                          },
                          child: SvgPicture.asset(
                            ImageConstant.delete,
                            height: 18,
                            width: 18,
                            color: ColorConstant.black,
                          ),
                        ),
                        Dimens.d10.spaceWidth,
                      ],),
                      Text(
                        affirmationList[index]["title"],
                        style: Style.cormorantGaramondBold(
                          fontSize: 18,
                        ),
                      ),
                      Dimens.d10.spaceHeight,
                      Text(
                        affirmationList[index]["des"],
                        style: Style.montserratRegular(fontSize: 11),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: affirmationDraftList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          "9:30",
                          style: Style.montserratRegular(
                            fontSize: 30,
                          ),
                        ), Text(
                          " PM",
                          style: Style.montserratRegular(
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddAffirmationPage(
                                  isEdit: true,
                                  title: affirmationDraftList[index]["title"],
                                  des: affirmationDraftList[index]["des"],
                                  isFromMyAffirmation: true,
                                );
                              },
                            ));
                          },
                          child: SvgPicture.asset(
                            ImageConstant.editTools,
                            height: 18,
                            width: 18,
                            color: ColorConstant.black,
                          ),
                        ),
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            affirmationDraftList.removeAt(index);
                            setState(() {

                            });
                          },
                          child: SvgPicture.asset(
                            ImageConstant.delete,
                            height: 18,
                            width: 18,
                            color: ColorConstant.black,
                          ),
                        ),
                        Dimens.d10.spaceWidth,
                      ],),
                      Text(
                        affirmationDraftList[index]["title"],
                        style: Style.cormorantGaramondBold(
                          fontSize: 18,
                        ),
                      ),
                      Dimens.d10.spaceHeight,
                      Text(
                        affirmationDraftList[index]["des"],
                        style: Style.montserratRegular(fontSize: 11),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],),
    );
  }
}
