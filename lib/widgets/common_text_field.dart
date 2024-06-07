import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';


class CommonTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget? prefixIcon;
  final String? prefixLottieIcon;
  final Widget? suffixIcon;
  final String? suffixLottieIcon;
  final String? suffixLottieIcon2;
  final bool isAutoFocus;
  final bool isSecure;
  final bool filterSelected;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? nextFocusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final GestureTapCallback? onTap;
  final VoidCallback? suffixTap;
  final VoidCallback? suffixTap2;
  final VoidCallback? prefixTap;
  final bool readOnly;
  final bool enabled;
  final bool showMultipleSuffix;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? heightFactor;
  final double? borderRadius;
  final Widget? prefix;
  final Widget? suffix;
  final Color? filledColor;
  final Matrix4? transform;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool? autovalidateMode;


  const CommonTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.focusNode,
      this.prefixIcon,
      this.prefixLottieIcon,
      this.isAutoFocus = false,
      this.isSecure = false,
      this.suffixIcon,
      this.suffixLottieIcon,
      this.keyboardType,
      this.textInputAction,
      this.nextFocusNode,
      this.inputFormatters,
      this.textCapitalization,
      this.onTap,
      this.readOnly = false,
      this.hintStyle,
      this.textStyle,
      this.labelText,
      this.labelStyle,
      this.prefixTap,
      this.suffixTap,
      this.maxLines,
      this.minLines,
      this.maxLength,
      this.onChanged,
      this.prefix,
      this.suffix,
      this.enabled = true,
      this.filterSelected = false,
      this.showMultipleSuffix = false,
      this.suffixLottieIcon2,
      this.filledColor,
      this.suffixTap2,
      this.heightFactor = 2.1,
      this.transform,
      this.validator,
    this.borderRadius = Dimens.d26,
    this.autovalidateMode,
  })
      : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> isFocus;
  late final AnimationController _lottieIconsController;
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    isFocus = ValueNotifier(false);
    widget.focusNode.addListener(
      () {
        if (widget.focusNode.hasFocus) {
          isFocus.value = true;
        } else {
          isFocus.value = false;
        }
      },
    );
    _lottieIconsController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieIconsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.labelText != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText!,
              style: widget.labelStyle ?? Style.montserratMedium(fontSize: 14)),
          Dimens.d10.spaceHeight,
          _textField()
        ],
      );
    } else {
      return _textField();
    }
  }

  Widget _textField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: widget.isSecure,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters ?? [],
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      // textCapitalization: widget.isSecure
      //     ? TextCapitalization.none
      //     : TextCapitalization.sentences,
      textAlignVertical: TextAlignVertical.center,
      expands: false,
      validator: widget.validator,
      enabled: widget.enabled,
      style: widget.textStyle ??
          Style.montserratMedium(fontSize: Dimens.d12, color: themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black),

      decoration: InputDecoration(
          alignLabelWithHint: true,
          isDense: true,
          filled: true,
          fillColor: widget.filledColor ?? (themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white),
          hintText: widget.hintText,
          counterStyle: Style.montserratRegular(),
          hintStyle: widget.hintStyle ??
              Style.montserratRegular(
                color: ColorConstant.hintText,
                fontWeight: FontWeight.w100,fontSize: Dimens.d12
              ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          borderRadius: widget.borderRadius?.radiusAll ?? Dimens.d26.radiusAll,
        ),
        contentPadding: EdgeInsets.only(
            top: Dimens.d14,
            bottom: Dimens.d14,
            left: Dimens.d20,
            right:
                (widget.suffixIcon != null || widget.suffixLottieIcon != null)
                    ? Dimens.d0
                    : Dimens.d10,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        prefix: widget.prefix,
        suffix: widget.suffix,

        errorStyle: Style.montserratRegular(color: ColorConstant.colorFF0000, fontSize: Dimens.d12),
        errorMaxLines: 2,

      ),

      onTap: widget.onTap,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onChanged: widget.onChanged,

    );
  }

  Widget? _iconButton(String? icon, VoidCallback? onTap, String? lottieIcon,
      {bool multiIcon = false, heightFactor = 2.2}) {

      if ((icon != null)) {
        return Align(
          alignment: Alignment.topCenter,
          widthFactor: 1,
          heightFactor: double.parse(((widget.maxLines ?? 0) / 2).toString()),
          child: InkWell(
            canRequestFocus: false,
            highlightColor: ColorConstant.transparent,
            splashColor: ColorConstant.transparent,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimens.d14, horizontal: Dimens.d20),
                child: Icon(Icons.remove_red_eye),
              // child: SvgPicture.asset(
              //   icon,
              //   width: Dimens.d18,
              //   height: Dimens.d18,
              // ),
            ),
          ),
        );
      } else {
        return null;
      }
    }

}
