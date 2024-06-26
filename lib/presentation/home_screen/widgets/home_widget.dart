import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/recently_model.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class BookmarkListTile extends StatelessWidget {
  Datum? dataList;

  BookmarkListTile({super.key, this.dataList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.d140,
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
          Container(
            margin: const EdgeInsets.all(7.0),
            height: 14,width: 14,
            decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
            child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
          )
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
      width: Dimens.d140,
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
          Container(
            margin: const EdgeInsets.all(7.0),
            height: 14,width: 14,
            decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
            child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
          )
        ],
      ),
    );
  }
}
