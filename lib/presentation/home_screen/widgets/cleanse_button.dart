import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';


class CleanseButton extends StatelessWidget {
  final int totalCount;
  const CleanseButton({super.key, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onAddNew(context),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorConstant.themeColor,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.d16)),
        ),
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16)),
                    child: SvgPicture.asset(ImageConstant.icCleanse))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 23.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Cleanse",
                          style: Style.cormorantGaramondMedium(
                              fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        CommonElevatedButton(
                            title: "Add New",
                            textStyle: Style.montserratRegular(fontSize: 12),
                            buttonColor: Colors.white,
                            height: 30,
                            width: 90,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            onTap: () {
                              _onAddNew(context);
                            })
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                      width: 74,
                      height: 94,
                      decoration:  BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(38))),
                      child: Center(
                          child: SvgPicture.asset(
                        ImageConstant.icCleanseToday,
                        color: Colors.white,
                      )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onAddNew(BuildContext context) {
    Get.toNamed(AppRoutes.todayCleanseScreen);

  }
}
