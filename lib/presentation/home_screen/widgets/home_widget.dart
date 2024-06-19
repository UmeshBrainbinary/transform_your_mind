import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class BookmarkListTile extends StatelessWidget {
  Datum? dataList;

  BookmarkListTile({Key? key, this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.d140,
      child: Stack(alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonLoadImage(
                url: "https://picsum.photos/250?image=9"?? '',
                width: Dimens.d140,
                height: Dimens.d144,
                borderRadius: Dimens.d16,
              ),
              Dimens.d18.spaceHeight,
              Text(
                "zhfgd" ?? '',
                style: Style.montserratRegular(
                  fontSize: Dimens.d12,
                ).copyWith(
                  letterSpacing: -Dimens.d0_48,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Dimens.d7.spaceHeight,
              Text(
              "Podsahdhsd" ?? '',
                style: Style.montserratRegular().copyWith(
                    letterSpacing: Dimens.d0_16,fontSize: Dimens.d12
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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