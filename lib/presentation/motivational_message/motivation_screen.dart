import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_message.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  MotivationalController motivationalController =
      Get.put(MotivationalController());
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    motivationalController.getMotivational();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      body: Column(
        children: [
          Dimens.d20.spaceHeight,
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 42,
                  width: 42,
                  margin: EdgeInsets.only(left: 21.h, top: 15.h, bottom: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.d5),
                      color: themeController.isDarkMode.value
                          ? ColorConstant.textfieldFillColor
                          : ColorConstant.white,
                      boxShadow: [
                        BoxShadow(
                          color: themeController.isDarkMode.value
                              ? ColorConstant.transparent
                              : ColorConstant.color8BA4E5.withOpacity(0.25),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ]),
                  child: Center(
                      child: Image.asset(
                    ImageConstant.backArrow,
                    height: 25.h,
                    width: 25.h,
                    color: themeController.isDarkMode.value
                        ? ColorConstant.white
                        : ColorConstant.black,
                  )),
                ),
              ),
              const Spacer(),
              Text(
                "motivationalMessages".tr,
                style: Style.nunitoBold(fontSize: 20),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => MotivationalMessageScreen(
                        skip: false,
                      ))!.then((value) {
                    motivationalController.pause();
                  },);
                },
                child: SvgPicture.asset(
                  ImageConstant.playMotivation,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
            ],
          ),
          Dimens.d20.spaceHeight,
          GetBuilder<MotivationalController>(
            id: "motivational",
            builder: (controller) {
              return Expanded(
                child: controller.loader.isTrue
                    ? const SizedBox()
                    : (controller.motivationalModel.data ?? []).isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                controller.motivationalModel.data?.length ?? 0,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return GestureDetector(onTap: () {
                                Get.to(()=>MotivationalMessageScreen(
                                  like: controller.motivationalModel
                                      .data![index].userLiked,
                                  id: controller.motivationalModel
                                      .data![index].id,

                                  skip: false,data: currentLanguage == "en-US" ||
                                    currentLanguage == ""
                                    ? controller.motivationalModel
                                    .data![index].message
                                    .toString()
                                    : controller.motivationalModel
                                    .data![index].gMessage ??
                                    "",back:true ,))!.then((value) {
                                  controller.pause();
                                    },);
                              },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            controller
                                                    .motivationalModel
                                                    .data![index]
                                                    .motivationalImage ??
                                                "",
                                          ),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 24),
                                    child: Center(
                                      child: Text(
                                        currentLanguage == "en-US" ||
                                                currentLanguage == ""
                                            ? controller.motivationalModel
                                                .data![index].message
                                                .toString()
                                            : controller.motivationalModel
                                                    .data![index].gMessage ??
                                                "",
                                        textAlign: TextAlign.center,
                                        maxLines: 4,
                                        style: Style.nunRegular(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    themeController.isDarkMode.isTrue
                                        ? ImageConstant.darkData
                                        : ImageConstant.noData),
                                Text(
                                  "dataNotFound".tr,
                                  style: Style.gothamMedium(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
              );
            },
          )
        ],
      ),
    );
  }
}
