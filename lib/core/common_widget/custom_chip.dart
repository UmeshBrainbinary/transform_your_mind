import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class CustomChip extends StatefulWidget {
  final String label;
  final bool? isFocusMain;

  final bool isChipSelected;
  final bool isParentPadding;

  const CustomChip({
    super.key,
    required this.label,
    this.isFocusMain = null,
    required this.isChipSelected,
    this.isParentPadding = true,
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {


  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.isParentPadding
          ? const EdgeInsets.symmetric(
              horizontal: Dimens.d6,
              vertical: Dimens.d6,
            )
          : EdgeInsets.zero,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(Dimens.d80)),
          gradient:themeController.isDarkMode.isTrue?const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.transparent,
              Colors.transparent,

            ],
          ): (widget.isFocusMain != null && widget.isFocusMain == true)
              ? const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    ColorConstant.themeColor,
                    ColorConstant.themeColor,
                  ],
                )
              : widget.isChipSelected
                  ? LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        ColorConstant.backgroundWhite.withOpacity(0.2),
                        ColorConstant.backgroundWhite.withOpacity(0.2)
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        ColorConstant.backgroundWhite.withOpacity(0.2),
                        ColorConstant.backgroundWhite.withOpacity(0.2)
                      ],
                    ),
          border: Border.all(
            color: themeController.isDarkMode.isTrue?Colors.white:Colors.black.withOpacity(Dimens.d0_2),
          ),
        ),
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.d14,
            horizontal: Dimens.d16,
          ),
          child: Text(
            widget.label,
            style: Style.nunMedium(
              color: (widget.isFocusMain != null && widget.isFocusMain == true)
                  ?  ColorConstant.textWhiteTransform
                  : widget.isChipSelected
                      ? ColorConstant.themeColor
                      : themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black,
              fontSize: Dimens.d15,
            ),
          ),
        ),
      ),
    );
  }
}
