import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';



class AddImageWidget extends StatefulWidget {
  final XFile? image;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;
  final String? imageURL;
  final bool hideDelete;
  final String? title;

  const AddImageWidget(
      {super.key,
      this.image,
      required this.onTap,
      required this.onDeleteTap,
      this.imageURL,
      this.hideDelete = false,
      this.title});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {

  ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dimens.d10.spaceHeight,
          SizedBox(
            height: Dimens.d110,
            width: Dimens.d110,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: Dimens.d100,
                    width: Dimens.d100,
                    child: widget.image != null
                        ? Image.file(
                            File(widget.image?.path ?? ""),
                            fit: BoxFit.cover,
                            height: Dimens.d100,
                            width: Dimens.d100,
                          )
                        : (widget.imageURL != null)
                            ? CommonLoadImage(
                                url: widget.imageURL ?? '',
                                height: Dimens.d100,
                                width: Dimens.d100,
                              )
                            : (widget.imageURL?.isNotEmpty ?? false)
                                ? const SizedBox()
                                : InkWell(
                                    onTap: widget.onTap,
                                    child: themeController.isDarkMode.isTrue
                                        ? SvgPicture.asset(ImageConstant
                                            .nonPlaceHolderProfileDark)
                                        : Image.asset(
                                            ImageConstant.nonPlaceHolderProfile,
                                            fit: BoxFit.cover,
                                            height: Dimens.d100,
                                            width: Dimens.d100,
                                          ),
                                  ),
                  ),
                ),

              ],
            ),
          ),
          Dimens.d10.spaceHeight,
          CommonElevatedButton(height: Dimens.d26,
            title: widget.title??'addProfileImage'.tr,
            onTap: widget.onTap,
            width: Dimens.d141,
            textStyle: Style.nunMedium(
                color: ColorConstant.white, fontSize: Dimens.d12),
          ),
        ],
      ),
    );
  }
}
