
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class RitualTile extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onDeleteTap;
  final String title;
  final String subTitle;
  final List<String>? multiSubTitle;
  final String image;
  final bool showDelete;
  final bool showEdit;
  final VoidCallback? onEditTap;
  final bool? location;

  const RitualTile({
    Key? key,
    required this.onTap,
    this.onDeleteTap,
    required this.title,
    required this.subTitle,
    required this.image,
    this.multiSubTitle,
    this.showDelete = false,
    this.showEdit = false,
    this.onEditTap,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDelete ? null : onTap,
      child: Padding(
        padding: location==true?const EdgeInsets.symmetric(horizontal: Dimens.d20,vertical: Dimens.d7):Dimens.d20.paddingAll,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Style.montserratRegular().copyWith(
                      letterSpacing: Dimens.d0_16,fontSize: Dimens.d14
                    ),
                  ),
                  // Dimens.d5.spaceHeight,
                  /* (subTitle.isNotEmpty)
                      ? Text(
                          subTitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Style.workSansRegular(
                            color: AppColors.textGreyColor,
                            fontSize: Dimens.d12,
                          ),
                        )
                      : const Offstage()*/
                ],
              ),
            ),
            Dimens.d10.spaceWidth,
            if (!showEdit)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: Dimens.d25.radiusAll,
                  onTap: onTap,
                  child: showDelete
                      ? SvgPicture.asset(
                          ImageConstant.icDelete,
                          color: Colors.red.withOpacity(0.5),
                        )
                      : Image.asset(
                          image,
                          height:location=="Home"?Dimens.d25:Dimens.d46,
                          width: location=="Home"?Dimens.d25:Dimens.d46,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            if (showEdit)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: Dimens.d25.radiusAll,
                  onTap: onEditTap,
                  child: SvgPicture.asset(
                    ImageConstant.icPencil,
                    color: Colors.black,
                    height: Dimens.d16,
                    width: Dimens.d16,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
