import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';

import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';

class EditAffirmationDialogWidget extends StatefulWidget {
  final VoidCallback onDeleteTap;
  final Function(String data) onSaveTap;
  final Function(String data) onDraftTap;

  const EditAffirmationDialogWidget({
    required this.onSaveTap,
    required this.onDeleteTap,
    required this.onDraftTap,
    Key? key,
  }) : super(key: key);

  @override
  State<EditAffirmationDialogWidget> createState() =>
      _EditAffirmationDialogWidgetState();
}

class _EditAffirmationDialogWidgetState
    extends State<EditAffirmationDialogWidget> {
  final TextEditingController _userAffirmationController =
      TextEditingController();
  final FocusNode _userAffirmationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
   /* if (widget.affirmation.title != null) {
      _userAffirmationController.text = widget.affirmation.title!;
    }*/
  }

  @override
  void dispose() {
    _userAffirmationController.dispose();
    _userAffirmationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: widget.onDeleteTap,
            child: SvgPicture.asset(
              ImageConstant.icDeleteWhite,
              color: ColorConstant.deleteRedLight,
            ),
          ),
        ),
        Dimens.d10.spaceHeight,
        Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "editCustomAffirmation".tr,
            style: Style.montserratRegular(
              fontSize: Dimens.d16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Dimens.d10.spaceHeight,
        CommonTextField(
          hintText: "editCustomAffirmation".tr,
          controller: _userAffirmationController,
          textInputAction: TextInputAction.done,
          focusNode: _userAffirmationFocusNode,
        ),
        LayoutContainer(
          child: Row(
            children: [
              Expanded(
                child: CommonElevatedButton(
                  title: "draft".tr,
                  outLined: true,
                  textStyle: Style.montserratRegular(color: ColorConstant.textDarkBlue),
                  onTap: () => isEmptyAffirmation
                      ? showSnackBarError(
                          context, "pleaseEnterYourOwnAffirmation".tr)
                      : widget
                          .onDraftTap(_userAffirmationController.text.trim()),
                ),
              ),
              Dimens.d20.spaceWidth,
              Expanded(
                child: CommonElevatedButton(
                  title: "save".tr,
                  onTap: () => isEmptyAffirmation
                      ? showSnackBarError(
                          context, "pleasEnterYourOwnAffirmation".tr)
                      : widget
                          .onSaveTap(_userAffirmationController.text.trim()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get isEmptyAffirmation => _userAffirmationController.text.trim().isEmpty;
}
