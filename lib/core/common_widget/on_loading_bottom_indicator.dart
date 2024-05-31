import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';

class OnLoadingFooter extends StatelessWidget {
  const OnLoadingFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Offstage();
        } else if (mode == LoadStatus.loading) {
          body = InkDropLoader(
            size: Dimens.d40,
            color: ColorConstant.themeColor,
          );
        } else if (mode == LoadStatus.failed) {
          body =  Text("loadFailedRetry".tr);
        } else if (mode == LoadStatus.canLoading) {
          body =  Text("releaseToLoadMore".tr);
        } else {
          body =  Text("NoMoreData".tr);
        }
        return SizedBox(
          height: Dimens.d55,
          child: Center(child: body),
        );
      },
    );
  }
}
