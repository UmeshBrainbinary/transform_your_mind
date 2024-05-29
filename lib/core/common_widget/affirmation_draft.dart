import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';


class AffirmationDraftListItem extends StatelessWidget {
  final int index;
  final List? listOfAffirmationDraftsResponse;
  final VoidCallback? onDeleteTapCallback;
  const AffirmationDraftListItem(
      {Key? key,
      required this.index,
      required this.listOfAffirmationDraftsResponse,
      this.onDeleteTapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.d325,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: Dimens.d16.radiusAll),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonLoadImage(
            imagePath: listOfAffirmationDraftsResponse?[index].imagePath ?? "",
            url: listOfAffirmationDraftsResponse?[index].imageUrl ?? '',
            width: Dimens.d88,
            height: Dimens.d92,
            borderRadius: Dimens.d16,
          ),
          Dimens.d12.spaceWidth,
          Expanded(
            child: Text(
              listOfAffirmationDraftsResponse?[index].title ??
                  "Something Went Wrong",
              style: Style.montserratRegular().copyWith(
                letterSpacing: Dimens.d0_16,
                height: Dimens.d1_5,
              ),
              maxLines: Dimens.d2.toInt(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => onDeleteTapCallback?.call(),
            child: SvgPicture.asset(
              ImageConstant.icDeleteWhite,
              color: ColorConstant.deleteRedLight,
            ),
          ),
          Dimens.d15.spaceWidth,
        ],
      ),
    );
  }
}
