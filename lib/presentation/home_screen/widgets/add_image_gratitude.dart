import 'dart:io';

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
            height: Dimens.d110,
            width: Dimens.d110,
            child: Stack(
              children: [
                widget.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(widget.image?.path ?? ""),
                          fit: BoxFit.cover,
                          height: Dimens.d100,
                          width: Dimens.d100,
                        ),
                    )
                    : (widget.imageURL != null)
                        ? CommonLoadImage(borderRadius: 10,
                            url: widget.imageURL ?? '',
                            height: Dimens.d100,
                            width: Dimens.d100,
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
                      child: Container(
                        padding: const EdgeInsets.all(Dimens.d5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),
                        child:const Icon(Icons.delete,color: Colors.red,),
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
