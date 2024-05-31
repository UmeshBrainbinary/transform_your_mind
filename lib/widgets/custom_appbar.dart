import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final bool? showBack;
  final TextStyle? titleStyle;
  final Widget? leading;
  final Widget? action;
  final VoidCallback? onTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.showBack = true,
    this.titleStyle,
    this.onTap,
    this.leading,
    this.action,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
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
    return AppBar(
      centerTitle: widget.centerTitle,
      title: Text(widget.title,
          style: widget.titleStyle ??
              Style.cormorantGaramondBold(fontSize: Dimens.d20)),
      backgroundColor: ColorConstant.transparent,
      leading: widget.leading ?? _getLeading(),
      //automaticallyImplyLeading: false,
      actions: [
        _getAction(),
      ],
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _getLeading() {
    return widget.showBack!?InkWell(
      onTap: widget.onTap ??
          () {
            Get.back();
            FocusScope.of(context).unfocus();
          },
      child: Container(
        height: Dimens.d50,
        width: Dimens.d40,
        margin: EdgeInsets.only(left: 21.h,top: 15.h,bottom: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.d5),
            color: ColorConstant.white,
            boxShadow: [
              BoxShadow(
                color: ColorConstant.color8BA4E5.withOpacity(0.25),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ]
        ),
        child: Center(child: Image.asset(ImageConstant.backArrow, height: 25.h,width: 25.h,)),
      ),
    ):const SizedBox();
  }

  Widget _getAction() {
    if (widget.action != null) {
      return Center(
        child: widget.action!,
      );
    }
    return const SizedBox.shrink();
  }
}
