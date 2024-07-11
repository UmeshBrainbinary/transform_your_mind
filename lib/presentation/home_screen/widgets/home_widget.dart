import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/recently_model.dart';
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
                          .montserratMedium(
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
                        "${ dataList?.rating.toString()}.0" ??
                            '',
                        style: Style
                            .montserratMedium(
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
                style: Style.montserratMedium(
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
                      style: Style.montserratMedium(
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
                        "${dataList?.rating.toString()}.0" ?? '',
                        style: Style.montserratMedium(
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
                style: Style.montserratMedium(fontSize: Dimens.d14),
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

  FeelGood({super.key, this.dataList});

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
                          .montserratMedium(
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
                        "${ dataList?.rating.toString()}.0" ??
                            '',
                        style: Style
                            .montserratMedium(
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
                style: Style.montserratMedium(
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

class PositiveMoment extends StatelessWidget {
  const PositiveMoment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: Dimens.d113,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonLoadImage(
            borderRadius: 10,
            url:
                "https://transformyourmind.s3.eu-north-1.amazonaws.com/1718865288873-3d connections polygonal background with connecting lines and dots.png",
            width: Dimens.d156,
            height: Dimens.d113,
          ),
          Center(
            child: SizedBox(
                width: Dimens.d125,
                child: Text(
                  "“When you have a dream, you’ve got to grab it and never let go”",
                  textAlign: TextAlign.center,
                  style: Style.gothamLight(
                      fontSize: 12, color: ColorConstant.white),
                )),
          )
        ],
      ),
    );
  }
}
