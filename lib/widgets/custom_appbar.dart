import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final bool? showBack;
  final TextStyle? titleStyle;
  final Widget? leading;
  final Widget? action;
  final VoidCallback? onTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBack = true,
    this.titleStyle,
    this.onTap,
    this.leading,
    this.action,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieBackBtnController;

  ThemeController themeController = Get.find<ThemeController>();

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
    return AppBar( shadowColor: Colors.transparent,
      forceMaterialTransparency: false,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: themeController.isDarkMode.isTrue
          ? const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light)
          : const SystemUiOverlayStyle(
              statusBarColor: ColorConstant.backGround,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark),
      centerTitle: widget.centerTitle,
      title: Text(widget.title,
          style: widget.titleStyle ??
              Style.montserratRegular(
                  fontSize: Dimens.d18,
                  color: themeController.isDarkMode.value
                      ? ColorConstant.white
                      : ColorConstant.black)),
      backgroundColor: ColorConstant.transparent,
      leading: widget.leading ?? _getLeading(),
      //automaticallyImplyLeading: false,
      actions: [
        _getAction(),
      ],
      elevation: 0,
    );
  }

  Widget _getLeading() {
    return widget.showBack!?InkWell(
      onTap: widget.onTap ??
          () {

                   Get.closeCurrentSnackbar();
                   Get.closeAllSnackbars();
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                },
      child: Container(
        height: Dimens.d50,
        width: Dimens.d40,
        margin: EdgeInsets.only(left: 21.h,top: 15.h,bottom: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.d5),
            color: themeController.isDarkMode.value ?  ColorConstant.textfieldFillColor : ColorConstant.white,
            boxShadow: [
              BoxShadow(
                color: themeController.isDarkMode.value ? ColorConstant.transparent : ColorConstant.color8BA4E5.withOpacity(0.25),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ]
        ),
        child: Center(child: Image.asset(ImageConstant.backArrow, height: 25.h,width: 25.h, color: themeController.isDarkMode.value ?  ColorConstant.white : ColorConstant.black,)),
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
