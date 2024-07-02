import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AffirmationShareScreen extends StatefulWidget {
  String? title;
  String? des;

  AffirmationShareScreen({super.key, this.title, this.des});

  @override
  State<AffirmationShareScreen> createState() => _AffirmationShareScreenState();
}

class _AffirmationShareScreenState extends State<AffirmationShareScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: true,
        title: "",
      ),
      body: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                Dimens.d26.spaceHeight,
                Stack(
                  children: [
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(
                          top: Dimens.d80,
                          right: Dimens.d20,
                          left: Dimens.d20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: Dimens.d8,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Dimens.d115.spaceHeight,
                          Text(
                            widget.title??"",
                            style: Style.cormorantGaramondBold(
                                color: ColorConstant.black,
                                fontSize: Dimens.d28),
                          ),
                          Dimens.d20.spaceHeight,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 23),
                            child: Text(
                              widget.des??"",
                              textAlign: TextAlign.center,
                              style: Style.montserratRegular(
                                  fontSize: Dimens.d14,
                                  color: ColorConstant.black),
                            ),
                          ),
                          Dimens.d40.spaceHeight,
                        ],
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        ImageConstant.splashLogo,
                        height: 160,
                        width: 160,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Dimens.d40.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: CommonElevatedButton(
              title: "share".tr,
              onTap: () {
                shareScreenShot();
              },
            ),
          ),
          Dimens.d40.spaceHeight,
        ],
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
        File imgFile = File(filePathAndName);
        await imgFile.writeAsBytes(capturedImage!);
        ShareResult res = await Share.shareXFiles([XFile(imgFile.path)]);

        if (res.status == ShareResultStatus.success) {}
      } catch (e) {}
    }).catchError((onError) {});
  }
}
