import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/message_view.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';


class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable(
      {super.key,
      this.message,
      this.showBottomHeight = true,
      this.horizontalPadding = 20});

  final String? message;
  final bool showBottomHeight;
  final double horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      vertical: Dimens.d0,
      horizontal: horizontalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            ImageConstant.lottieNoDataForRestoring,
            fit: BoxFit.fill,
            height: Dimens.d170.h,
          ),
          MessageView(
            title: message ??"No Data Available",
            details: '',
          ),
          SizedBox(height: showBottomHeight ? 100.h : 0)
        ],
      ),
    );
  }
}
