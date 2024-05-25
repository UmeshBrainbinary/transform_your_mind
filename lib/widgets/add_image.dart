import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';



class AddImageWidget extends StatefulWidget {
  final XFile? image;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;
  final String? imageURL;
  final bool hideDelete;

  const AddImageWidget(
      {Key? key,
      this.image,
      required this.onTap,
      required this.onDeleteTap,
      this.imageURL,
      this.hideDelete = false})
      : super(key: key);

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.image == null && widget.imageURL == null)
            Text(StringConstant.addProfileImage, style: Style.montserratRegular(color: ColorConstant.white)),
          Dimens.d10.spaceHeight,
          // SizedBox(
          //   height: Dimens.d90,
          //   width: Dimens.d90,
          //   child: Stack(
          //     children: [
          //       ClipRRect(
          //         borderRadius: Dimens.d16.radiusAll,
          //         child: Container(
          //           alignment: Alignment.topLeft,
          //           height: Dimens.d80,
          //           width: Dimens.d80,
          //           child: widget.image != null
          //               ? Hero(
          //                 tag: widget.image?.path ?? '',
          //                 child: Image.file(
          //                   File(widget.image?.path ?? ""),
          //                   fit: BoxFit.cover,
          //                   height: Dimens.d80,
          //                   width: Dimens.d80,
          //                 ),
          //               )
          //               : (widget.imageURL != null)
          //                   ? Hero(
          //                     tag: widget.imageURL ?? '',
          //                     child: CommonLoadImage(
          //                       url: widget.imageURL ?? '',
          //                       height: Dimens.d80,
          //                       width: Dimens.d80,
          //                     ),
          //                   )
          //                   : (widget.imageURL?.isNotEmpty ?? false)
          //                       ? const SizedBox()
          //                       : Material(
          //                           color: ColorConstant.transparent,
          //                           child: InkWell(
          //                             onTap: widget.onTap,
          //                             borderRadius: Dimens.d16.radiusAll,
          //                             child: Container(
          //                               height: Dimens.d80,
          //                               width: Dimens.d80,
          //                               decoration: BoxDecoration(
          //                                 borderRadius: Dimens.d16.radiusAll,
          //                               ),
          //                               child: SvgPicture.asset(
          //                                 AppAssets.icAdd,
          //                                 fit: BoxFit.fill,
          //                                 color: themeManager.colorThemed5,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //         ),
          //       ),
          //       if ((widget.image != null || widget.imageURL != null) &&
          //           !widget.hideDelete)
          //         Align(
          //           alignment: Alignment.bottomRight,
          //           child: GestureDetector(
          //             onTap: widget.onDeleteTap,
          //             child: Container(
          //               padding: const EdgeInsets.all(Dimens.d5),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(24),
          //                 color: Colors.white,
          //               ),
          //               child: SvgPicture.asset(
          //                 AppAssets.icDeleteWhite,
          //                 fit: BoxFit.fill,
          //                 color: AppColors.deleteRed,
          //                 height: Dimens.d20,
          //                 width: Dimens.d20,
          //               ),
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
