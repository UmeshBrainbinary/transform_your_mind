import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/support_screen/support_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    ThemeController themeController = Get.find<ThemeController>();
    SupportController supportController = Get.put(SupportController());
    //statusBarSet(themeController);

    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "contactSupport".tr),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimens.d100),
                      child: SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.profile1Dark
                          : ImageConstant.profile1),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimens.d300),
                      child: SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.profile2Dark
                          : ImageConstant.profile2),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Dimens.d15.spaceHeight,
                        CommonTextField(
                            labelText: "name".tr,
                            hintText: "enterName".tr,
                            focusNode: supportController.nameFocus,
                            controller: supportController.name,
                            validator: (value) {
                              if (value == "") {
                                return "theNameFieldIsRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d24.h.spaceHeight,
                        CommonTextField(
                          labelText: "email".tr,
                          hintText: "enterEmail".tr,
                          focusNode: supportController.emailFocus,
                          prefixIcon: Image.asset(ImageConstant.email,
                              scale: Dimens.d4),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == "") {
                              return "theEmailFieldIsRequired".tr;
                            } else if (!isValidEmail(value, isRequired: true)) {
                              return "pleaseEnterValidEmail".tr;
                            }
                            return null;
                          },
                          controller: supportController.email,
                        ),
                        Dimens.d24.h.spaceHeight,
                        CommonTextField(
                            labelText: "comment".tr,
                            hintText: "enterComment".tr,
                            controller: supportController.comment,
                            focusNode: supportController.commentFocus,
                            maxLines: 7,
                            validator: (value) {
                              if (value == "") {
                                return "theCommentFiledRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d50.spaceHeight,
                        CommonElevatedButton(
                          title: "submit".tr,
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              await supportController.addSupport(context: context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => supportController.loader.isTrue
                ? commonLoader()
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
