import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/widget/view_fullscreen_image.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';



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


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.image == null && widget.imageURL == null)
            Text("addImage".tr, style: Style.montserratMedium()),
          Dimens.d10.spaceHeight,
          SizedBox(
            height: Dimens.d90,
            width: Dimens.d90,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: Dimens.d16.radiusAll,
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: Dimens.d80,
                    width: Dimens.d80,
                    child: widget.image != null
                        ? GestureDetector(
                      onTap: () {

                        Get.toNamed(AppRoutes.fullScreenImage, arguments: {
                          "imageUrl": widget.image?.path ?? '',
                          "isNetworkImage": false
                        });


                      },
                      child: Hero(
                        tag: widget.image?.path ?? '',
                        child: Image.file(
                          File(widget.image?.path ?? ""),
                          fit: BoxFit.cover,
                          height: Dimens.d80,
                          width: Dimens.d80,
                        ),
                      ),
                    )
                        : (widget.imageURL != null)
                        ? GestureDetector(
                      onTap: () {



                        Get.toNamed(AppRoutes.fullScreenImage, arguments: {
                          "imageUrl": widget.image?.path ?? '',
                          "isNetworkImage": true
                        });
                      },
                      child: Hero(
                        tag: widget.imageURL ?? '',
                        child: CommonLoadImage(
                          url: widget.imageURL ?? '',
                          height: Dimens.d80,
                          width: Dimens.d80,
                        ),
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
                          height: Dimens.d80,
                          width: Dimens.d80,
                          decoration: BoxDecoration(
                            borderRadius: Dimens.d16.radiusAll,
                          ),
                          child: SvgPicture.asset(
                            ImageConstant.editAdd,
                            fit: BoxFit.fill,
                            color: ColorConstant.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if ((widget.image != null || widget.imageURL != null) && !widget.hideDelete)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: widget.onDeleteTap,
                      child: Container(
                        padding: const EdgeInsets.all(Dimens.d5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),



                          child: const Icon(Icons.delete_outline, color: ColorConstant.colorFF0000, size:
                        15,)
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
