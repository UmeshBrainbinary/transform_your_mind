import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
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

  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    supportController.getFaqList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: const CustomAppBar(title: "FAQ"),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimens.d100),
                child: SvgPicture.asset(ImageConstant.profile1),
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(ImageConstant.profile2),
              )),
          Column(
            children: [
              Dimens.d10.spaceHeight,
              Expanded(
                  child: ListView.builder(
                itemCount: supportController.faqList?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = supportController.faqList?[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                                  data?.question ?? "",
                                  style: Style.montserratSemiBold(fontSize: 14),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    supportController.faq[index] =
                                        !supportController.faq[index];
                                  });
                                },
                                child: SvgPicture.asset(
                                  supportController.faq[index]
                                      ? ImageConstant.upArrowFaq
                                      : ImageConstant.downArrowFaq,
                                  height: 18,
                                  width: 18,
                                  color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.white
                                      : ColorConstant.black,
                                )),
                          ],
                        ),
                        supportController.faq[index]
                            ? Column(
                                children: [
                                  const Divider(
                                    thickness: 0.7,
                                  ),
                                  Text(
                                    data?.answer ?? "",
                                    style: Style.montserratRegular(fontSize: 10)
                                        .copyWith(height: 1.5),
                                  )
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ],
      ),
    );
  }
}
