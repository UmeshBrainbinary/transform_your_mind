import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';


class HomeMessagePage extends StatefulWidget {
  final bool fromNotification;

  const HomeMessagePage(
      {Key? key, this.fromNotification = false})
      : super(key: key);

  @override
  State<HomeMessagePage> createState() => _HomeMessagePageState();
}

class _HomeMessagePageState extends State<HomeMessagePage> {
  bool _isBookmarked = false;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
      //  Navigator.of(context).pop(widget.affirmationData?.isBookMarked);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.backGround,
        body: Stack(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Stack(
                alignment: Alignment.center,
                children: [
                const SizedBox(   height: double.infinity,
                  width: double.infinity,),
                  Image.asset(
                     ImageConstant.homeBg,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      color: ColorConstant.themeColor,
                      opacity: const AlwaysStoppedAnimation(.85)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 45, vertical: 20.h),
                    child: AutoSizeText(
                      "displayNameTransformYourMind".tr,
                      textAlign: TextAlign.center,
                      wrapWords: false,
                      maxLines: 6,
                      style: Style.montserratRegular(fontSize: Dimens.d30),
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.d8),
                    child: IconButton(
                      onPressed: () {
                        if (widget.fromNotification) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return DashBoardScreen();
                          },));
                        } else {
                          Navigator.pop(context,);
                        }
                      },
                      icon: Lottie.asset(
                        ImageConstant.lottieArrowLef,
                        height: Dimens.d24,
                        width: Dimens.d24,
                        fit: BoxFit.cover,
                        repeat: false,
                      ),
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
                          textStyle: Style.montserratRegular(
                            fontSize: Dimens.d14,
                          ),
                          onTap: () {
                            if (_isBookmarked) {
                              _isBookmarked = false;
                         /*     widget.affirmationData?.isBookMarked = false;

                              bookmarkBloc.add(RefreshBookmarksEvent());

                              bookmarkBloc.add(
                                RemoveMyBookmarkEvent(
                                  bookmarkId:
                                  widget.affirmationData?.id ?? '',
                                ),
                              );*/
                              Navigator.pop(context,);
                            } else {
                              _isBookmarked = true;
                        /*      widget.affirmationData?.isBookMarked = true;

                              bookmarkBloc.add(RefreshBookmarksEvent());
                              bookmarkBloc.add(
                                AddMyBookmarkEvent(
                                  addBookmarkRequest: AddBookmarkRequest(
                                    contentType: 2,
                                    contentId: widget.affirmationData?.id,
                                  ),
                                ),
                              );*/
                            }
                          }),
                    ),
                    Dimens.d20.spaceWidth,
                    Expanded(
                      child: CommonElevatedButton(
                        title: "share".tr,
                        prefixIcon: ImageConstant.icShareWhite,
                        textStyle: Style.montserratRegular(
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
