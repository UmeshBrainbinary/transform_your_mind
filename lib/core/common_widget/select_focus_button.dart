import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';



class FocusSelectButton extends StatelessWidget {
  final String primaryBtnText, secondaryBtnText;
  final Function? primaryBtnCallBack;
  final bool isLoading;

  const FocusSelectButton({
    super.key,
    required this.primaryBtnText,
    required this.secondaryBtnText,
    required this.primaryBtnCallBack,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.d100,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimens.d40),
        child: Column(
          children: [
            const Spacer(),
            !isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                    child: CommonElevatedButton(
                      title: primaryBtnText,
                      onTap: () {
                        primaryBtnCallBack?.call();
                      },
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.d20),
                    child: LoadingButton(),
                  ),
          ],
        ),
      ),
    );
  }
}
