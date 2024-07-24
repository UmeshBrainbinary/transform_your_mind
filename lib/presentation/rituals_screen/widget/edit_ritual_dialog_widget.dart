import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';


class EditRitualDialogWidget extends StatefulWidget {
  final VoidCallback onDeleteTap;
  final Function(String data) onSaveTap;
  final Function(String data) onDraftTap;

  const EditRitualDialogWidget({
    required this.onSaveTap,
    required this.onDeleteTap,
    required this.onDraftTap,
    Key? key,
  }) : super(key: key);

  @override
  State<EditRitualDialogWidget> createState() => _EditRitualDialogWidgetState();
}

class _EditRitualDialogWidgetState extends State<EditRitualDialogWidget> {
  final TextEditingController _userRitualController = TextEditingController();
  final FocusNode _userRitualFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
/*    if (widget.ritual.ritualName != null) {
      _userRitualController.text = widget.ritual.ritualName!;
    }*/
  }

  @override
  void dispose() {
    _userRitualController.dispose();
    _userRitualFocusNode.dispose();
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
              color:ColorConstant.deleteRedLight,
            ),
          ),
        ),
        Dimens.d10.spaceHeight,
        Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Edit Custom Ritual",
            style: Style.montserratBold(
              fontSize: Dimens.d16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Dimens.d10.spaceHeight,
        CommonTextField(
          hintText: "Edit Custom Ritual",
          controller: _userRitualController,
          textInputAction: TextInputAction.done,
          focusNode: _userRitualFocusNode,
        ),
        LayoutContainer(
          child: Row(
            children: [
              Expanded(
                child: CommonElevatedButton(
                  title:"Draft",
                  outLined: true,
                  textStyle: Style.nunRegular(color: ColorConstant.textDarkBlue),
                  onTap: () => isEmptyRitual
                      ? showSnackBarError(context,"Please Add Own Rituals")
                      : widget.onDraftTap(_userRitualController.text.trim()),
                ),
              ),
              Dimens.d20.spaceWidth,
              Expanded(
                child: CommonElevatedButton(
                  title: "Save",
                  onTap: () => isEmptyRitual
                      ? showSnackBarError(context,"Please Add Own Rituals")
                      : widget.onSaveTap(_userRitualController.text.trim()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get isEmptyRitual => _userRitualController.text.trim().isEmpty;
}
