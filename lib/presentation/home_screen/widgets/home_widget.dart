import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/recently_model.dart';
import 'package:transform_your_mind/model_class/self_hypnotic_model.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class BookmarkListTile extends StatelessWidget {
  Datum? dataList;

  BookmarkListTile({super.key, this.dataList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.d156,
      child: Stack(alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  CommonLoadImage(
                    borderRadius: 10,
                    url: dataList?.image??
                        "",
                    width: Dimens.d156,
                    height: Dimens.d113,
                  ),
                  Align(
                    alignment:
                    Alignment.topRight,
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 10,
                          top: 10),
                      child: SvgPicture.asset(
                          ImageConstant.play),
                    ),
                  )
                ],
              ),
              Dimens.d10.spaceHeight,
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      dataList?.name
                          .toString()??"",
                      // "Motivational",
                      style: Style
                          .nunMedium(
                        fontSize: Dimens.d12,
                      ),
                      overflow: TextOverflow
                          .ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 2,
                    backgroundColor:
                    ColorConstant
                        .colorD9D9D9,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.rating,
                        color: ColorConstant
                            .colorFFC700,
                        height: 10,
                        width: 10,
                      ),
                      Text(
                        "${ dataList?.rating.toString()}.0",
                        style: Style
                            .nunMedium(
                          fontSize:
                          Dimens.d12,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Dimens.d7.spaceHeight,
              Text(
                dataList?.description
                    .toString()??"",
                maxLines: Dimens.d2.toInt(),
                style: Style.nunMedium(
                    fontSize: Dimens.d14),
                overflow:
                TextOverflow.ellipsis,
              ),
            ],
          ),
          !dataList!.isPaid!?Container(
            margin: const EdgeInsets.all(7.0),
            height: 14,width: 14,
            decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
            child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
          ):const SizedBox()
        ],
      ),
    );
  }
}

class RecentlyPlayed extends StatelessWidget {
  RecentlyData? dataList;
  RecentlyPlayed({super.key, this.dataList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.d156,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  CommonLoadImage(
                    borderRadius: 10,
                    url: dataList?.image ?? "",
                    width: Dimens.d156,
                    height: Dimens.d113,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: SvgPicture.asset(ImageConstant.play),
                    ),
                  )
                ],
              ),
              Dimens.d10.spaceHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      dataList?.name.toString() ?? "",
                      // "Motivational",
                      style: Style.nunMedium(
                        fontSize: Dimens.d12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 2,
                    backgroundColor: ColorConstant.colorD9D9D9,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.rating,
                        color: ColorConstant.colorFFC700,
                        height: 10,
                        width: 10,
                      ),
                      Text(
                        "${dataList?.rating.toString()}.0",
                        style: Style.nunMedium(
                          fontSize: Dimens.d12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Dimens.d7.spaceHeight,
              Text(
                dataList?.description.toString() ?? "",
                maxLines: Dimens.d2.toInt(),
                style: Style.nunMedium(fontSize: Dimens.d14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          !dataList!.isPaid!
              ? Container(
                  margin: const EdgeInsets.all(7.0),
                  height: 14,
                  width: 14,
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: Center(
                      child: Image.asset(
                    ImageConstant.lockHome,
                    height: 7,
                    width: 7,
                  )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class FeelGood extends StatelessWidget {
  AudioData? dataList;
  String? audioTime,currentLanguage;
  FeelGood({super.key, this.dataList,this.audioTime,this.currentLanguage});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: Dimens.d156,
      child: Stack(alignment: Alignment.topRight,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  CommonLoadImage(
                    borderRadius: 10,
                    url: dataList?.image??
                        "",
                    width: Dimens.d156,
                    height: Dimens.d113,
                  ),
                  Align(
                    alignment:
                    Alignment.topRight,
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 10,
                          top: 10),
                      child: SvgPicture.asset(
                          ImageConstant.play),
                    ),
                  ),
                  Positioned( bottom: 5.0,
                    right: 5.0,
                    child: Container(padding:  EdgeInsets.only(top: Platform.isIOS?0: 1),
                      height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(13)),
                    child: Center(child: Text(audioTime!,style: Style.nunRegular(fontSize: 6,color: Colors.white),)) ,),
                  )
                ],
              ),
              Dimens.d10.spaceHeight,
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      dataList?.name
                          .toString()??"",
                      // "Motivational",
                      style: Style
                          .nunitoBold(
                        fontSize: Dimens.d10,
                      ),
                      overflow: TextOverflow
                          .ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 2,
                    backgroundColor:
                    ColorConstant
                        .colorD9D9D9,
                  ),
                  Dimens.d10.spaceWidth,
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.rating,
                        color: ColorConstant
                            .colorFFC700,
                        height: 10,
                        width: 10,
                      ),
                      Dimens.d3.spaceWidth,

                      Text(
                        "${ dataList?.rating.toString()}.0",
                        style: Style
                            .nunMedium(
                          fontSize:
                          Dimens.d12,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Dimens.d7.spaceHeight,
              Text(
               dataList?.description??"",
                maxLines: Dimens.d2.toInt(),
                style: Style.nunMedium(
                    fontSize: Dimens.d14),
                overflow:
                TextOverflow.ellipsis,
              ),
            ],
          ),
          if (!dataList!.isPaid!) Align(alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(7.0),
              height: 14,width: 14,
              decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
              child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
            ),
          ) else const SizedBox()
        ],
      ),
    );
  }
}
class SelfHypnoticScreen extends StatelessWidget {
  SelfHypnoticData? dataList;
  String? audioTime,currentLanguage;
  SelfHypnoticScreen({super.key, this.dataList,this.audioTime,this.currentLanguage});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: Dimens.d156,
      child: Stack(alignment: Alignment.topRight,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  CommonLoadImage(
                    borderRadius: 10,
                    url: dataList?.image??
                        "",
                    width: Dimens.d156,
                    height: Dimens.d113,
                  ),
                  Align(
                    alignment:
                    Alignment.topRight,
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 10,
                          top: 10),
                      child: SvgPicture.asset(
                          ImageConstant.play),
                    ),
                  ),
                  Positioned( bottom: 5.0,
                    right: 5.0,
                    child: Container(padding:  EdgeInsets.only(top: Platform.isIOS?0: 1),
                      height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(13)),
                    child: Center(child: Text(audioTime!,style: Style.nunRegular(fontSize: 6,color: Colors.white),)) ,),
                  )
                ],
              ),
              Dimens.d10.spaceHeight,
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      dataList?.name
                          .toString()??"",
                      // "Motivational",
                      style: Style
                          .nunitoBold(
                        fontSize: Dimens.d10,
                      ),
                      overflow: TextOverflow
                          .ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 2,
                    backgroundColor:
                    ColorConstant
                        .colorD9D9D9,
                  ),
                  Dimens.d10.spaceWidth,
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.rating,
                        color: ColorConstant
                            .colorFFC700,
                        height: 10,
                        width: 10,
                      ),
                      Dimens.d3.spaceWidth,

                      Text(
                        "${ dataList?.rating.toString()}.0",
                        style: Style
                            .nunMedium(
                          fontSize:
                          Dimens.d12,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Dimens.d7.spaceHeight,
              Text(
               dataList?.description??"",
                maxLines: Dimens.d2.toInt(),
                style: Style.nunMedium(
                    fontSize: Dimens.d14),
                overflow:
                TextOverflow.ellipsis,
              ),
            ],
          ),
          if (!dataList!.isPaid!) Align(alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(7.0),
              height: 14,width: 14,
              decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
              child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
            ),
          ) else const SizedBox()
        ],
      ),
    );
  }
}


class PositiveMoment extends StatelessWidget {
  int? index;
   PositiveMoment({super.key,this.index});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    PositiveController positiveController = Get.find<PositiveController>();
    return Container(
      height: 156,
      width: 156,
      margin: const EdgeInsets.only(right: 22),
      padding: const EdgeInsets.only(
          left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : ColorConstant.colorDCE9EE,
          borderRadius:
          BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          CommonLoadImage(
              borderRadius: 10.0,
              url:
              positiveController.filteredBookmarks?[
              index!]["img"] ??
                  "",
              width: Dimens.d139,
              height: Dimens.d101),
          Dimens.d10.spaceHeight,
          Text(
            positiveController
                .filteredBookmarks?[index!]
            ['title'] ??
                "",
            maxLines: 1,
            style: Style.nunMedium(
                fontSize: Dimens.d14),
            overflow: TextOverflow.ellipsis,
          ),

        ],
      ),
    );
  }
}
