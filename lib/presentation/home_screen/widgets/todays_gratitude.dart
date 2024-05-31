import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';



class TodaysGratitude extends StatefulWidget {
  const TodaysGratitude({Key? key}) : super(key: key);

  @override
  State<TodaysGratitude> createState() => _TodaysGratitudeState();
}

class _TodaysGratitudeState extends State<TodaysGratitude> {

  final TextEditingController titleController = TextEditingController();
  final FocusNode gratitudeFocus = FocusNode();
  bool isAddNew = false;
  int totalCount = 0;
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  File? selectedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
         "today'sGratitude".tr,
          style: Style.montserratRegular(
            fontSize: Dimens.d22
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.d19,
          ),
          child: ValueListenableBuilder(
              valueListenable: imageFile,
              builder: (context, value, child) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: imageFile.value != null
                            ? Dimens.d20
                            : Dimens.d0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: Dimens.d26.radiusAll,
                        color: ColorConstant.themeColor.withOpacity(0.9),
                      ),
                      child: Row(
                        children: [

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.gratitudeScreen);
                              },
                              child: CommonTextField(
                                controller: titleController,
                                focusNode: gratitudeFocus,
                                hintText: "writeYourGratitude".tr,
                                textStyle: Style.montserratRegular(
                                    color: Colors.black,
                                    fontSize: Dimens.d14),
                                maxLines: 6,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                enabled: false,
                                onTap: () {
                                  Get.toNamed(AppRoutes.gratitudeScreen);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: Dimens.d20,
                      right: Dimens.d20,
                      child: isAddNew
                          ? GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.gratitudeScreen);

                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              ImageConstant.bgImagePlaying,
                              height: Dimens.d18,
                              width: Dimens.d18,
                              fit: BoxFit.fill,
                              repeat: false,
                            ),
                            Dimens.d5.spaceWidth,
                            Text(
                              "edit".tr,
                              style: Style.montserratRegular(
                                color: ColorConstant.themeColor,
                                fontSize: Dimens.d14,
                              ),
                            ),
                          ],
                        ),
                      )
                          : (imageFile.value == null)
                          ? GestureDetector(
                        onTap: () async {
                          Get.toNamed(AppRoutes.gratitudeScreen);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              ImageConstant.icAddImage,
                              width: Dimens.d18,
                              height: Dimens.d18,
                              color: ColorConstant.themeColor,
                            ),
                            Dimens.d5.spaceWidth,
                            Text(
                             "addImage".tr,
                              style: Style.montserratRegular(
                                color:ColorConstant.themeColor,
                                fontSize: Dimens.d11,
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                );
              }),
        ),
        isAddNew
            ? CommonElevatedButton(
          title: "addNew".tr,
          textStyle: Style.montserratRegular(
            color: ColorConstant.white,
            fontSize: Dimens.d14,
          ),
          onTap: () {

          },
        )
            : const SizedBox.shrink(),
      ],
    );
  }


}
