import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class FolderDescriptionPage extends StatelessWidget {
  final EdgeInsets margin;
  final String title;
  final String type;
  final String createdDate;
  final String image;
  final bool showDelete;
  final VoidCallback? onDeleteTapCallback;
  final String description;

  const FolderDescriptionPage({
    Key? key,
    required this.margin,
    required this.title,
    required this.createdDate,
    required this.image,
    this.showDelete = false,
    this.onDeleteTapCallback,
    required this.type,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: Dimens.d335,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Dimens.d16.radiusAll,
      ),
      child: Row(
        children: [
          Dimens.d16.spaceWidth,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.d17.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Style.montserratBold(fontSize: Dimens.d16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Dimens.d16.spaceWidth,
                      if (showDelete)
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
                  Dimens.d2.spaceHeight,
                  Row(
                    children: [
                      Text(
                        createdDate.isNotEmpty
                            ? DateTimeUtils.formatDate(
                                DateTime.parse(createdDate),
                                formatDateType: FormatDateType.ddMMMyyyy,
                              )
                            : "",
                        style: Style.montserratMedium(
                            fontSize: Dimens.d12,
                            color: ColorConstant.textGreyColorLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Dimens.d10.spaceWidth,
                      Container(
                        height: 15,
                        width: 1,
                        color: ColorConstant.textGreyColorLight,
                      ),
                      Dimens.d10.spaceWidth,
                      SizedBox(
                        width: Dimens.d200,
                        child: Text(
                          description,
                          style: Style.montserratMedium(
                              fontSize: Dimens.d12,
                              color: ColorConstant.textGreyColorLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Dimens.d2.spaceHeight,
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.icEditFolderBorder,
                        height: 20,
                        width: 20,
                      ),
                      Dimens.d10.spaceWidth,
                      Text(
                        type,
                        style: Style.montserratMedium(
                            fontSize: Dimens.d12,
                            color: ColorConstant.textGreyColorLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AllNotesJournal extends StatelessWidget {
  final EdgeInsets margin;
  final String title;
  final String type;
  final String createdDate;
  final String image;
  final bool showDelete;
  final VoidCallback? onDeleteTapCallback;
  final String description;

  const AllNotesJournal({
    Key? key,
    required this.margin,
    required this.title,
    required this.createdDate,
    required this.image,
    this.showDelete = false,
    this.onDeleteTapCallback,
    required this.type,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: Dimens.d335,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Dimens.d16.radiusAll,
      ),
      child: Row(
        children: [
          Dimens.d16.spaceWidth,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.d17.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Style.montserratMedium(fontSize: Dimens.d16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Dimens.d16.spaceWidth,
                      if (showDelete)
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
                  Dimens.d2.spaceHeight,
                  Row(
                    children: [
                      Text(
                        DateTimeUtils.formatDate(
                          DateTime.parse(createdDate),
                          formatDateType: FormatDateType.ddMMMyyyy,
                        ),
                        style: Style.montserratMedium(
                            fontSize: Dimens.d12,
                            color: ColorConstant.textGreyColorLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Dimens.d10.spaceWidth,
                      Container(
                        height: 15,
                        width: 1,
                        color: ColorConstant.textGreyColorLight,
                      ),
                      Dimens.d10.spaceWidth,
                      SizedBox(
                        width: Dimens.d200,
                        child: Text(
                          description,
                          style: Style.montserratMedium(
                              fontSize: Dimens.d12,
                              color: ColorConstant.textGreyColorLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Dimens.d2.spaceHeight,
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.icEditFolderBorder,
                        height: 20,
                        width: 20,
                      ),
                      Dimens.d10.spaceWidth,
                      Text(
                        type,
                        style: Style.montserratMedium(
                            fontSize: Dimens.d12,
                            color: ColorConstant.textGreyColorLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
