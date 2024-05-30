import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class HomeAppBar extends StatefulWidget {
  final String? title;
  final bool isInfo;
  final VoidCallback? onInfoTap;
  final VoidCallback? onRatingTap;
  final bool fromHomeTab;
  final bool? downloadShown;
  final Widget? downloadWidget;
  final bool showMeIcon;
  final bool ratings;
  final bool ratingViewUi;
  final bool back;

  const HomeAppBar(
      {Key? key,
      this.title,
      this.isInfo = false,
      this.fromHomeTab = false,
      this.onInfoTap,
      this.onRatingTap,
      this.downloadShown,
      this.downloadWidget,
      this.showMeIcon = true,
      this.ratings = false,
      this.ratingViewUi = false,
      required this.back})
      : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with TickerProviderStateMixin {
  late final AnimationController _lottieBackBtnController;

  @override
  void initState() {
    super.initState();
    _lottieBackBtnController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieBackBtnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.back == true
            ? InkWell(
                borderRadius: Dimens.d28.radiusAll,
                onTap: () {
                  Get.back();
                },
                child: Lottie.asset(
                  ImageConstant.lottieArrowLef,
                  controller: _lottieBackBtnController,
                  height: Dimens.d24,
                  width: Dimens.d24,
                  onLoaded: (composition) {
                    _lottieBackBtnController
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              )
            : const SizedBox(),
        Container(
          height: Dimens.d35,
          alignment: Alignment.center,
          child: Text(
            widget.title ?? "",
            style: Style.cormorantGaramondBold(fontSize: Dimens.d20),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(ImageConstant.download,
                  height: Dimens.d25, width: Dimens.d25),
            ),
            Dimens.d10.h.spaceWidth,
            GestureDetector(
              onTap:widget.onInfoTap!,
              child: SvgPicture.asset(ImageConstant.information,
                  height: Dimens.d25, width: Dimens.d25),
            ),
            Dimens.d10.h.spaceWidth,
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(ImageConstant.notification,
                  height: Dimens.d25, width: Dimens.d25),
            ),
          ],
        ),
      ],
    );
  }
}
