import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';


class HomeMessagePage extends StatefulWidget {
  final bool fromNotification;
  String? motivationalMessage;

   HomeMessagePage(
      {super.key, this.fromNotification = false,this.motivationalMessage});

  @override
  State<HomeMessagePage> createState() => _HomeMessagePageState();
}

class _HomeMessagePageState extends State<HomeMessagePage> {
  bool _isBookmarked = false;
  ScreenshotController screenshotController = ScreenshotController();
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.isTrue
            ? ColorConstant.darkBackground
            : ColorConstant.backGround,
        body: Stack(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/share_background.png",
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20.h),
                    child: AutoSizeText(
                      "“${widget.motivationalMessage}”",
                      textAlign: TextAlign.center,
                      wrapWords: false,
                      maxLines: 6,
                      style: Style.nunRegular(fontSize: Dimens.d23,color: ColorConstant.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: Dimens.d44,
              left: Dimens.d0,
              right: Dimens.d0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                  onTap: () {
                    if (widget.fromNotification) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const DashBoardScreen();
                      },));
                    } else {
                      Navigator.pop(context,);
                    }
                  },
                    child: Container(
                      height: Dimens.d40,
                      width: Dimens.d40,
                      margin: EdgeInsets.only(left: 21.h,top: 15.h,bottom: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.d5),
                          color: themeController.isDarkMode.value ?  ColorConstant.textfieldFillColor : ColorConstant.white,
                          boxShadow: [
                            BoxShadow(
                              color: themeController.isDarkMode.value ? ColorConstant.transparent : ColorConstant.color8BA4E5.withOpacity(0.25),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ),
                          ]
                      ),
                      child: Center(child: Image.asset(ImageConstant.backArrow, height: 25.h,width: 25.h, color: themeController.isDarkMode.value ?  ColorConstant.white : ColorConstant.black,)),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.d20, vertical: Dimens.d36),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonElevatedButton(
                          title: _isBookmarked ? "remove".tr : "save".tr,
                          outLined: true,
                          textStyle: Style.nunRegular(
                            fontSize: Dimens.d14,color: ColorConstant.white
                          ),
                          onTap: () {
                            if (_isBookmarked) {
                              _isBookmarked = false;

                              Navigator.pop(context,);
                            } else {
                              _isBookmarked = true;

                            }
                          }),
                    ),
                    Dimens.d20.spaceWidth,
                    Expanded(
                      child: CommonElevatedButton(
                        title: "share".tr,
                        prefixIcon: ImageConstant.icShareWhite,
                        textStyle: Style.nunRegular(
                          color: Colors.white,
                          fontSize: Dimens.d14,
                        ),
                        onTap: () => shareScreenShot(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareScreenShot() {
    // invoking capture on screenshotController
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      try {
        final documentDirectory = await getApplicationDocumentsDirectory();
        String filePathAndName =
            '${documentDirectory.path}/${'transform'}${math.Random().nextInt(1000)}_shoorah.png';
        log("filePathAndName ==$filePathAndName");
        File imgFile = File(filePathAndName);
        await imgFile.writeAsBytes(capturedImage!);
        ShareResult res = await Share.shareXFiles([XFile(imgFile.path)]);

        if (res.status == ShareResultStatus.success) {

        }
      } catch (e) {
        log('affirmation sharing error == $e');
      }
    }).catchError((onError) {
      log(onError);
    });
  }
}
