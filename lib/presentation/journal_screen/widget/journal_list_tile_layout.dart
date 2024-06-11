import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class JournalListTileLayout extends StatelessWidget {
  final EdgeInsets margin;
  final String title;
  final String createdDate;
  final String image;
  final bool showDelete;
  final VoidCallback? onDeleteTapCallback;

  const JournalListTileLayout({
    Key? key,
    required this.margin,
    required this.title,
    required this.createdDate,
    required this.image,
    this.showDelete = false,
    this.onDeleteTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();

    return Container(
      height: Dimens.d70.h,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? ColorConstant.textfieldFillColor
            : ColorConstant.white,
        borderRadius: Dimens.d16.radiusAll,
      ),
      child: Row(
        children: [
          /*CommonLoadImage(
            url: image,
            width: Dimens.d90,
            height: Dimens.d70,
            customBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimens.d10),
              bottomLeft: Radius.circular(Dimens.d10),
            ),
          ),*/
          Dimens.d16.spaceWidth,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d1.spaceHeight,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Style.montserratRegular(
                          fontSize: Dimens.d18,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
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
                          color: Colors.transparent,
                        ),
                      ),
                    Dimens.d15.spaceWidth,
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "createdOn".tr,
                        style: Style.montserratRegular(
                          fontSize: Dimens.d12,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
                      ),
                      const WidgetSpan(
                        child: Padding(padding: EdgeInsets.all(Dimens.d4)),
                      ),
                      TextSpan(
                        text: createdDate.isNotEmpty
                            ? DateTimeUtils.formatDate(
                                DateTime.parse(createdDate),
                                formatDateType: FormatDateType.ddMMMyyyy,
                              )
                            : "29 May 2024",
                        style: Style.montserratRegular(
                          color: ColorConstant.themeColor,
                          fontSize: Dimens.d12,
                        ),
                      ),
                    ],
                  ),
                ),
                Dimens.d5.spaceHeight,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class JournalDraftListTileLayout extends StatelessWidget {
  final EdgeInsets margin;
  final String title;
  final String createdDate;
  final String image;
  final bool showDelete;
  final VoidCallback? onDeleteTapCallback;

  const JournalDraftListTileLayout({
    Key? key,
    required this.margin,
    required this.title,
    required this.createdDate,
    required this.image,
    this.showDelete = false,
    this.onDeleteTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    return Container(
      width: Dimens.d335,
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? ColorConstant.textfieldFillColor
            : ColorConstant.white,
        borderRadius: Dimens.d10.radiusAll,
      ),
      child: Row(
        children: [

          Dimens.d16.spaceWidth,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d1.spaceHeight,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Style.montserratRegular(
                          fontSize: Dimens.d18,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
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
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                    Dimens.d15.spaceWidth,
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "createdOn".tr,
                        style: Style.montserratRegular(
                          fontSize: Dimens.d12,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
                      ),
                      const WidgetSpan(
                        child: Padding(padding: EdgeInsets.all(Dimens.d4)),
                      ),
                      TextSpan(
                        text: createdDate.isNotEmpty
                            ? DateTimeUtils.formatDate(
                                DateTime.parse(createdDate),
                                formatDateType: FormatDateType.ddMMMyyyy,
                              )
                            : "29 May 2024",
                        style: Style.montserratRegular(
                          color: ColorConstant.themeColor,
                          fontSize: Dimens.d12,
                        ),
                      ),
                    ],
                  ),
                ),
                Dimens.d5.spaceHeight,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class JournalListTileNotesLayout extends StatelessWidget {
  final EdgeInsets margin;
  final String title;
  final String desc;
  final String createdDate;
  final String image;
  final bool showDelete;
  final bool showTime;
  final VoidCallback? onDeleteTapCallback;
  final String type;

  const JournalListTileNotesLayout({
    Key? key,
    required this.margin,
    required this.title,
    required this.desc,
    required this.createdDate,
    required this.image,
    this.showDelete = false,
    this.showTime = false,
    this.onDeleteTapCallback,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Dimens.d16.radiusAll,
      ),
      child: Row(
        children: [
          Dimens.d16.spaceWidth,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.d20.h),
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
                        ),
                      ),
                      if (showDelete)
                        GestureDetector(
                          onTap: () => onDeleteTapCallback?.call(),
                          child: SvgPicture.asset(
                            ImageConstant.icDeleteWhite,
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ),
                      Dimens.d15.spaceWidth,
                    ],
                  ),
                  Dimens.d10.spaceHeight,
                  Row(
                    children: [
                      Text(
                        DateTimeUtils.formatDate(
                          DateTime.parse(createdDate),
                          formatDateType: FormatDateType.ddMMMyyyy,
                        ),
                        style: Style.montserratRegular(
                            fontSize: Dimens.d12,
                            color: Colors.grey.withOpacity(0.8)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Dimens.d10.spaceWidth,
                      Container(
                        height: 15,
                        width: 1,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      Dimens.d10.spaceWidth,
                      SizedBox(
                        width: Dimens.d200,
                        child: Text(
                          desc,
                          style: Style.montserratRegular(
                              fontSize: Dimens.d12,
                              color: Colors.grey.withOpacity(0.8)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Dimens.d10.spaceHeight,
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
                        style: Style.montserratRegular(
                            fontSize: Dimens.d12,
                            color: Colors.grey.withOpacity(0.8)),
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
