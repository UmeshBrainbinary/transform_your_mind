import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class AddImageEditWidget extends StatefulWidget {
  final XFile? image;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;
  final String? imageURL;
  final bool hideDelete;
  final String? title;

  const AddImageEditWidget(
      {super.key,
      this.image,
      required this.onTap,
      required this.onDeleteTap,
      this.imageURL,
      this.hideDelete = false,
      this.title});

  @override
  State<AddImageEditWidget> createState() => _AddImageEditWidgetState();
}

class _AddImageEditWidgetState extends State<AddImageEditWidget> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              widget.image == null
                  ? Container(
                      height: Dimens.d100,
                      width: Dimens.d100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: widget.imageURL != null
                          ? Container(
                        decoration: BoxDecoration(border: Border.all(color: ColorConstant.themeColor),
                        shape: BoxShape.circle),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: NetworkImage(
                                      widget.imageURL??""),
                                  fit: BoxFit.fill,
                                ),
                              ),
                          )
                          : SvgPicture.asset(
                              themeController.isDarkMode.isTrue?ImageConstant.nonPlaceHolderProfileDark:ImageConstant.userProfile,
                            ),
                    )

                  : Container(

                      height: Dimens.d100,
                      width: Dimens.d100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(File(widget.image?.path ?? "")),
                              fit: BoxFit.cover),
                          border: Border.all(
                              color: ColorConstant.themeColor, width: 2)),
                    ),
              if ((widget.image != null || widget.imageURL != null) &&
                  !widget.hideDelete)
                Padding(
                  padding: const EdgeInsets.only(left: 80, top:50 ),
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.onDeleteTap,
                      child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                          ),
                          child: Center(child: SvgPicture.asset(ImageConstant.deleteProfile,color: Colors.red,height: 12,width: 12,))),
                    ),
                  ),
                ),
            ],
          ),
          Dimens.d20.spaceHeight,
          if (widget.image == null && widget.imageURL == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d90),
              child: CommonElevatedButton(height: 26,
                title: "addProfileImage".tr,
                textStyle: Style.nunMedium(
                    fontSize: 12, color: ColorConstant.white),
                onTap: widget.onTap,
              ),
            ),
        ],
      ),
    );
  }
}
