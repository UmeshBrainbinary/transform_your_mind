
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/style.dart';

void showSnackBarError(
    final BuildContext context,
    String msg,
    ) {
  if (msg.isNotEmpty) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        backgroundColor: ColorConstant.deleteRedLight,
        textStyle:  TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Dimens.d14,
            fontFamily: FontFamily.nunitoRegular,
            color: Colors.white),
        message: msg,
      ),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.up],
    );
  }
}

void showSnackBarBottom(
    {required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Style.nunRegular(fontSize: Dimens.d15),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.d15)),
    ),
  );
}

void showSnackBarSuccess(
    final BuildContext context,
    String msg,
    ) {
  if (msg.isNotEmpty) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        backgroundColor: ColorConstant.themeColor,
        message: msg,icon: const SizedBox(),
        textStyle:  TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Dimens.d14,
            fontFamily: FontFamily.nunitoRegular,
            color: Colors.white),
      ),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.up],
    );
  }
}

void showSnackBarSuccessForgot(
    final BuildContext context,
    String msg,
    ) {
  if (msg.isNotEmpty) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        maxLines: 3,
        backgroundColor: ColorConstant.black.withOpacity(0.4),
        message: msg,
        textStyle:  TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Dimens.d14,
            fontFamily: FontFamily.nunitoRegular,
            color: Colors.white),
      ),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.up],
    );
  }
}