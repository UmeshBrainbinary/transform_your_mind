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
                        ? Hero(
                          tag: widget.image?.path ?? '',
                          child: Image.file(
                            File(widget.image?.path ?? ""),
                            fit: BoxFit.cover,
                            height: Dimens.d100,
                            width: Dimens.d100,
                          ),
                        )
                        : (widget.imageURL != null)
                            ? Hero(
                              tag: widget.imageURL ?? '',
                              child: CommonLoadImage(
                                url: widget.imageURL ?? '',
                                height: Dimens.d100,
                                width: Dimens.d100,
                              ),
                            )
                            : (widget.imageURL?.isNotEmpty ?? false)
                                ? const SizedBox()
                                : Material(
                                    color: ColorConstant.transparent,
                                    child: InkWell(
                                      onTap: widget.onTap,
                                      borderRadius: Dimens.d16.radiusAll,
                                      child: Container(
                                        height: Dimens.d100,
                                        width: Dimens.d100,
                                        decoration: BoxDecoration(
                                          borderRadius: Dimens.d16.radiusAll,
                                        ),
                                        child: SvgPicture.asset(
                                          ImageConstant.nonPlaceHolder,
                                          fit: BoxFit.cover,
                                          color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
                                        ),
                                      ),
                                    ),
                                  ),
                  ),
                ),

                /// image delete function

                // if ((widget.image != null || widget.imageURL != null) &&
                //     !widget.hideDelete)
                //   Align(
                //     alignment: Alignment.bottomRight,
                //     child: GestureDetector(
                //       onTap: widget.onDeleteTap,
                //       child: Container(
                //         padding: const EdgeInsets.all(Dimens.d5),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(24),
                //           color: Colors.white,
                //         ),
                //         child: SvgPicture.asset(
                //           ImageConstant.userPlaceHolder,
                //           fit: BoxFit.cover,
                //           height: Dimens.d20,
                //           width: Dimens.d20,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          Dimens.d10.spaceHeight,
          CommonElevatedButton(
            title: widget.title??'addProfileImage'.tr,
            onTap: widget.onTap,
            width: Dimens.d200,
            textStyle: Style.montserratMedium(color: ColorConstant.white, fontSize: Dimens.d14),
          ),
        ],
      ),
    );
  }
}
