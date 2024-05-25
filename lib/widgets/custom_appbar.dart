import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
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
    this.showBack = false,
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
          style:
              widget.titleStyle ?? Style.cormorantGaramondMedium(fontSize: Dimens.d25)),
      backgroundColor: ColorConstant.transparent,
      leading: widget.leading ?? _getLeading(),
      automaticallyImplyLeading: false,
      actions: [
        _getAction(),
      ],
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,

    );
  }

  Widget _getLeading() {


      return InkWell(
        borderRadius: Dimens.d28.radiusAll,
        onTap: widget.onTap ??
            () {
              Get.back();
            },
        child: Container(
          height: Dimens.d15,
          width: Dimens.d15,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.d10),
            color: ColorConstant.white
          ),
          child: Image.asset(ImageConstant.backArrow, scale: Dimens.d4),
        ),
      );


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
