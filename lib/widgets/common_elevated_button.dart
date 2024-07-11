import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';



class CommonElevatedButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final bool outLined;
  final Color? borderColor;
  final Color? buttonColor;
  final String? prefixIcon;
  final EdgeInsets? contentPadding;

  const CommonElevatedButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.textStyle,
      this.height,
      this.width,
      this.outLined = false,
      this.borderColor,
      this.prefixIcon,
      this.contentPadding,
      this.buttonColor});

  @override
  State<CommonElevatedButton> createState() => _CommonElevatedButtonState();
}

class _CommonElevatedButtonState extends State<CommonElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.outLined
          ? ColorConstant.transparent
          : widget.buttonColor ?? ColorConstant.themeColor,

      borderRadius: Dimens.d26.radiusAll,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: Dimens.d26.radiusAll,
        child: Container(
          height: widget.height ?? Dimens.d46.h,
          width:  widget.width,
          padding: widget.contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: Dimens.d18,
              ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: widget.outLined
                ? Border.all(
                    color: widget.borderColor ?? ColorConstant.themeColor,
                    width: Dimens.d1,
                  )
                : null,
            borderRadius: Dimens.d26.radiusAll,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: widget.textStyle ??
                    Style.nunRegular(
                        fontSize: Dimens.d20, color: ColorConstant.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Color? borderColor;

  const LoadingButton({Key? key, this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.d48.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorConstant.transparent,
        borderRadius: BorderRadius.circular(Dimens.d26),
        border: Border.all(
            color: borderColor ?? ColorConstant.themeColor, width: 0.5),
      ),
      child: SizedBox(
        height: Dimens.d35.h,
        child: const CircularProgressIndicator(
            color: ColorConstant.backGround,
          )
      ),
    );
  }
}
