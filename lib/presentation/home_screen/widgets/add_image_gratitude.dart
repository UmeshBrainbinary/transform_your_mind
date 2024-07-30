import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';



class AddGratitudeImageWidget extends StatefulWidget {
  final XFile? image;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;
  final String? imageURL;
  final bool hideDelete;
  final String? title;

  const AddGratitudeImageWidget(
      {super.key,
      this.image,
      required this.onTap,
      required this.onDeleteTap,
      this.imageURL,
      this.hideDelete = false,
      this.title});

  @override
  State<AddGratitudeImageWidget> createState() => _AddGratitudeImageWidgetState();
}

class _AddGratitudeImageWidgetState extends State<AddGratitudeImageWidget> {


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dimens.d10.spaceHeight,
          SizedBox(
            height: 82,
            width: 90,
            child: Stack(
              children: [
                if (widget.image != null)
                  DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      color: ColorConstant.themeColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(widget.image?.path ?? ""),
                          fit: BoxFit.cover,
                          height: 82,
                          width: 82,
                        ),
                      ))
                else
                  (widget.imageURL != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DottedBorder(
                            strokeWidth: 1,
                            radius: const Radius.circular(12),
                            color: ColorConstant.themeColor,
                            child: CommonLoadImage(
                              borderRadius: 10,
                              url: widget.imageURL ?? '',
                              height: 82,
                              width: 82,
                            ),
                          ),
                        )
                      : (widget.imageURL?.isNotEmpty ?? false)
                            ? const SizedBox()
                            : InkWell(
                              onTap: widget.onTap,
                              borderRadius: Dimens.d16.radiusAll,
                              child: SvgPicture.asset(
                                ImageConstant.icAdd,
                                 color: ColorConstant.themeColor,
                              ),
                            ),

                /// image delete function

                if ((widget.image != null || widget.imageURL != null) &&
                    !widget.hideDelete)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: widget.onDeleteTap,
                      child: Container(height: 20,width: 20,
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(Dimens.d5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            ImageConstant.deleteProfile,
                            color: Colors.red,
                            height: 12,
                            width: 12,
                          ))),
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
