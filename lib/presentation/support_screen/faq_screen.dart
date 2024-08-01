import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/support_screen/support_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  SupportController supportController = Get.put(SupportController());
  String currentLanguage = PrefService.getString(PrefKey.language);

  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    if (await isConnected()) {
      supportController.getFaqList();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: const CustomAppBar(title: "FAQ"),
          body: GetBuilder<SupportController>(id: "update",builder: (controller) {
            return   Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimens.d100),
                      child: SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.profile1Dark
                          : ImageConstant.profile1),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.d120),
                      child: SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.profile2Dark
                          : ImageConstant.profile2),
                    )),
                Column(
                  children: [
                    Dimens.d10.spaceHeight,
                    Expanded(
                        child: ListView.builder(
                          itemCount: controller.faqData?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = controller.faqData?[index];
                            return GestureDetector(onTap: () {
                              setState(() {
                                controller.faq[index] =
                                !controller.faq[index];
                              });
                            },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                decoration: BoxDecoration(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.textfieldFillColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: 260,
                                            child: Text(
                                            currentLanguage == "en-US"
                                                ? data?.question ?? ""
                                                : data?.gQuestion ?? "",
                                            style: Style.nunitoSemiBold(fontSize: 14),
                                            )),
                                        SvgPicture.asset(
                                          controller.faq[index]
                                              ? ImageConstant.upArrowFaq
                                              : ImageConstant.downArrowFaq,
                                          height: 18,
                                          width: 18,
                                          color: themeController.isDarkMode.isTrue
                                              ? ColorConstant.white
                                              : ColorConstant.black,
                                        ),
                                      ],
                                    ),
                                    controller.faq[index]
                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(
                                          thickness: 0.7,
                                        ),
                                        Text(
                                              currentLanguage == "en-US"
                                                  ? data?.answer ?? ""
                                                  : data?.gAnswer ?? "",
                                              textAlign: TextAlign.start,
                                          style: Style.nunRegular(fontSize: 10)
                                              .copyWith(height: 1.5),
                                        )
                                      ],
                                    )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                  ],
                ),
              ],
            );
          },),
        ),
        Obx(() => supportController.loader.isTrue?commonLoader():const SizedBox(),)
      ],
    );
  }
}
