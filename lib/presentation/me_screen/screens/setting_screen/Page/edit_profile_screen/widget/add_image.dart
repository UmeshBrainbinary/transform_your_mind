import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
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


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(alignment: Alignment.center,
            children: [
              widget.imageURL!=null
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.fullScreenImage, arguments: {
                          "imageUrl": widget.image?.path ?? '',
                          "isNetworkImage": false
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: Dimens.d30),
                        height: Dimens.d100,
                        width: Dimens.d100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                image: NetworkImage(
                                    "https://picsum.photos/250?image=9"),fit: BoxFit.cover),
                            border: Border.all(
                                color: ColorConstant.themeColor, width: 2)),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.fullScreenImage, arguments: {
                          "imageUrl": widget.image?.path ?? '',
                          "isNetworkImage": false
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: Dimens.d30),
                        height: Dimens.d100,
                        width: Dimens.d100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    FileImage(File(widget.image?.path ?? "")),fit: BoxFit.cover),
                            border: Border.all(
                                color: ColorConstant.themeColor, width: 2)),
                      ),
                    ),
              /*   ClipRRect(
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
              ),*/
              if ((widget.image != null || widget.imageURL != null) &&
                  !widget.hideDelete)
                Padding(
                  padding: const EdgeInsets.only(left: 50,bottom: 50),
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.onDeleteTap,
                      child: Container(height: 30,width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: ColorConstant.colorFF0000,
                            size: 15,
                          )),
                    ),
                  ),
                ),
            ],
          ),
          Dimens.d14.spaceHeight,
          if (widget.image == null && widget.imageURL == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d90),
              child: CommonElevatedButton(
                title: "addProfileImage".tr,textStyle: Style.montserratMedium(fontSize: 10,color: ColorConstant.white),
                onTap: widget.onTap,
              ),
            ),
        ],
      ),
    );
  }
}
