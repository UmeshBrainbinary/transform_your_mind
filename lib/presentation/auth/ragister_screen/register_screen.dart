import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:transform_your_mind/presentation/auth/ragister_screen/widget/add_image.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: StringConstant.register,
      ),
      body: SafeArea(
          child: Stack(
            children: [

              Positioned(
                top: Dimens.d200.h,
                right: null,
                left:  0,
                child: Transform.rotate(
                  angle: 3.14,
                  child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Dimens.d30.h.spaceHeight,

                                    ValueListenableBuilder(
                                      valueListenable: registerController.imageFile,
                                      builder: (context, value, child) {
                                        return AddImageWidget(
                                          onTap: () async {
                                            await showImagePickerActionSheet(context)
                                                ?.then((value) async {
                                              if (value != null) {

                                                registerController.imageFile.value = value;
                                              }
                                            });
                                          },
                                          onDeleteTap: () async {

                                            registerController.imageFile = ValueNotifier(null);
                                            if (registerController.image != null) {
                                              registerController.urlImage = null;
                                              //_isImageRemoved = true;
                                            }

                                          },
                                          image: registerController.imageFile.value,
                                          imageURL: registerController.urlImage,
                                        );



                                      },
                                    ),
                                    Dimens.d16.h.spaceHeight,
                                    CommonTextField(
                                        labelText: StringConstant.name,
                                        hintText: StringConstant.enterName,
                                        controller: registerController.nameController,
                                        focusNode: FocusNode(),
                                        prefixIcon: SvgPicture.asset(ImageConstant.user, height: Dimens.d5, width: Dimens.d5),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null ||
                                              (!isText(value, isRequired: true))) {
                                            return StringConstant.theNameFieldIsRequired;
                                          }
                                          return null;
                                        }
                                    ),
                                    Dimens.d16.h.spaceHeight,
                                    CommonTextField(
                                        labelText: StringConstant.email,
                                        hintText: StringConstant.enterEmail,
                                        controller: registerController.emailController,
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(ImageConstant.email, scale: Dimens.d4),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null ||
                                              (!isValidEmail(value, isRequired: true))) {
                                            return StringConstant.theEmailFieldIsRequired;
                                          }
                                          return null;
                                        }
                                    ),
                                    Dimens.d16.h.spaceHeight,
                                    ValueListenableBuilder(
                                      valueListenable: registerController.securePass,
                                      builder: (context, value, child) {
                                        return CommonTextField(
                                          labelText: StringConstant.password,
                                          hintText: StringConstant.enterPassword,
                                          controller: registerController.passwordController,
                                          validator: (value) {
                                            if (value == null || (!isValidPassword(value, isRequired: true))) {
                                              return StringConstant.thePasswordFieldIsRequired;
                                            }
                                            return null;
                                          },
                                          focusNode: FocusNode(),
                                          prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                          suffixIcon: registerController.securePass.value
                                              ? GestureDetector(
                                              onTap: (){
                                                registerController.securePass.value = !registerController.securePass.value;
                                              },
                                              child: Image.asset(ImageConstant.eyeClose, scale: Dimens.d5))

                                              : GestureDetector(
                                              onTap: (){
                                                registerController.securePass.value = !registerController.securePass.value;
                                              },
                                              child:   Image.asset(ImageConstant.eyeOpen, scale: Dimens.d6)),
                                          isSecure: value,
                                          //suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                          textInputAction: TextInputAction.done,
                                        );
                                      },
                                    ),
                                    Dimens.d16.h.spaceHeight,
                                    CommonTextField(
                                        labelText: "dateOfBirth".tr,
                                        hintText: "DD/MM/YYYY",
                                        controller: registerController.dobController,
                                        focusNode: FocusNode(),
                                        prefixIcon: SvgPicture.asset(ImageConstant.calendar, height: Dimens.d5, width: Dimens.d5),
                                        readOnly: true,
                                        onTap: () => picker.DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1900, 3, 5),
                                            maxTime: DateTime.now()
                                                .subtract(const Duration(days: 1)),
                                            theme: picker.DatePickerTheme(
                                                doneStyle: Style.montserratSemiBold(
                                                    color: ColorConstant.white),
                                                cancelStyle: Style.montserratSemiBold(
                                                    color: ColorConstant.white),
                                                itemStyle: Style.montserratSemiBold(
                                                    color: ColorConstant.white),
                                                backgroundColor: ColorConstant.themeColor),
                                            onChanged: (date) {}, onConfirm: (date) {
                                              registerController.dobController.text =
                                                  DateTimeUtils.formatDate(date);
                                              registerController.selectedDob = date;
                                            },
                                            currentTime: registerController.selectedDob ??
                                                DateTime.now().subtract(const Duration(days: 1)),
                                            locale: picker.LocaleType.en),
                                        validator: (value) {
                                          if (value == null ||
                                              (!isText(value, isRequired: true))) {
                                            return StringConstant.theEmailFieldIsRequired;
                                          }
                                          return null;
                                        }
                                    ),

                                    Dimens.d16.h.spaceHeight,
                                    CommonTextField(
                                        labelText: "gender".tr,
                                        hintText: "selectGender".tr,
                                        controller: registerController.genderController,
                                        focusNode: FocusNode(),
                                        prefixIcon: SvgPicture.asset(ImageConstant.gender, height: Dimens.d5, width: Dimens.d5),
                                        readOnly: true,
                                        suffixIcon: SvgPicture.asset(ImageConstant.downArrow, height: Dimens.d5, width: Dimens.d5),
                                        onTap: (){
                                          registerController.isDropGender.value = !registerController.isDropGender.value;
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              (!isText(value, isRequired: true))) {
                                            return StringConstant.theEmailFieldIsRequired;
                                          }
                                          return null;
                                        }
                                    ),

                                    Obx(
                                        () => registerController.isDropGender.value
                                            ? Container(
                                             height: Dimens.d200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimens.d10),
                                            ),
                                        ) : SizedBox(),
                                    ),




                                    Dimens.d80.h.spaceHeight,
                                    Obx(
                                          () =>  (registerController.loader.value)
                                          ? const LoadingButton()
                                          : CommonElevatedButton(
                                        title: StringConstant.register,
                                        onTap: () async{

                                          FocusScope.of(context).unfocus();

                                          if (_formKey.currentState!.validate()) {

                                            //await controller.loginWithEmailAndPassword();

                                          }

                                        },
                                      ),
                                    ),
                                    Dimens.d30.h.spaceHeight,
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "alreadyHaveAnAccount".tr,
                                            style: Style.montserratRegular(

                                            ),
                                          ),
                                          const WidgetSpan(
                                            child: Padding(
                                                padding:
                                                EdgeInsets.all(Dimens.d4)),
                                          ),
                                          TextSpan(
                                            text: StringConstant.login,
                                            style: Style.montserratSemiBold(
                                              color: ColorConstant.themeColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Get.toNamed(
                                                //   AppRoutes.loginScreen,
                                                // );
                                                Get.back();
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Dimens.d80.h.spaceHeight,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //commonGradiantContainer(color: AppColors.backgroundWhite, h: 20)
                      ],
                    );
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
