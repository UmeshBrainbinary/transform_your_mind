import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/message_view.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


class JournalNoDataWidget extends StatelessWidget {
  const JournalNoDataWidget(
      {super.key,
      required this.showBottomHeight,
      required this.title,
      required this.onClick});

  final bool showBottomHeight;
  final String title;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "getStarted".tr,
            style: Style.cormorantGaramondBold(color: ColorConstant.themeColor),
          ),
          Dimens.d20.spaceHeight,
          GestureDetector(
            onTap: () => onClick(),
            child: SvgPicture.asset(
              ImageConstant.addTools,
              height: Dimens.d50,
              width: Dimens.d50,
            ),
          ),
          Dimens.d20.spaceHeight,

          MessageView(
            title: title,
            details: '',
          ),
          SizedBox(
            height: showBottomHeight ? 80.h : 0.h,
          )
        ],
      ),
    );
  }
}


class CleanseNoData extends StatelessWidget {
  const CleanseNoData(
      {super.key,
        required this.showBottomHeight,
        required this.title,
        required this.onClick});

  final bool showBottomHeight;
  final String title;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      vertical: Dimens.d0,
      horizontal: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "addYourCleanse".tr,
              style: Style.montserratRegular(color: Colors.black.withOpacity(0.7),
                  fontSize: Dimens.d19.h),
            ),
            Dimens.d20.h.spaceHeight,
            GestureDetector(
              onTap: () => onClick(),
              child: Lottie.asset(
                ImageConstant.lottieNavAdd,
                fit: BoxFit.fill,
                height: Dimens.d80.h,
              ),
            ),
            Dimens.d18.h.spaceHeight,
            Text(
              "releaseCleanse".tr,
              style: Style.montserratRegular( fontSize: Dimens.d14.h,
                color:  Colors.black.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: showBottomHeight ? 80.h : 0.h,
            )
          ],
        ),
      ),
    );
  }
}
