import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController descController = TextEditingController();
  FocusNode descFocus = FocusNode();
  int maxLength = 50;
  int maxLengthDesc = 2000;
  ValueNotifier<int> currentLength = ValueNotifier(0);
  ThemeController themeController = Get.put(ThemeController());
  int? _currentRating = 0;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.black
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "feedback".tr),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(ImageConstant.profile2),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d30.spaceHeight,
                  CommonTextField(
                    hintText: "enterName".tr,
                    labelText: "name".tr,
                    controller: nameController,
                    focusNode: nameFocus,
                    nextFocusNode: titleFocus,
                    prefixLottieIcon: ImageConstant.lottieTitle,
                  ),
                  Dimens.d20.spaceHeight,
                  CommonTextField(
                    hintText: "enterTitle".tr,
                    labelText: "title".tr,
                    controller: titleController,
                    focusNode: titleFocus,
                    nextFocusNode: descFocus,
                    prefixLottieIcon: ImageConstant.lottieTitle,
                  ),
                  Dimens.d20.spaceHeight,
                  CommonTextField(
                    hintText: "comment".tr,
                    labelText: "enterComment".tr,
                    controller: descController,
                    focusNode: descFocus,
                    transform: Matrix4.translationValues(0, -108, 0),
                    prefixLottieIcon: ImageConstant.lottieDescription,
                    maxLines: 15,
                    maxLength: maxLengthDesc,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(maxLengthDesc),
                    ],
                    onChanged: (value) {
                      currentLength.value = descController.text.length;
                    },
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  Dimens.d30.spaceHeight,
                  Text(
                    "rating".tr,
                    style: Style.cormorantGaramondBold(fontSize: 20),
                  ),
                  Dimens.d10.spaceHeight,
                  Text(
                    "How would you rate your experience?".tr,
                    style: Style.montserratRegular(fontSize: 13),
                  ),
                  Dimens.d20.spaceHeight,
                  Container(
                    height: Dimens.d54,
                    width: 315,
                    decoration: BoxDecoration(
                        color: themeController.isDarkMode.isTrue
                            ? ColorConstant.textfieldFillColor
                            : ColorConstant.white,
                        borderRadius: BorderRadius.circular(9)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                            onTap: () {
                              setState.call(() {
                                _currentRating = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SvgPicture.asset(
                                index < _currentRating!
                                    ? ImageConstant.rating
                                    : ImageConstant.rating,
                                color: index < _currentRating!
                                    ? ColorConstant.colorFFC700
                                    :ColorConstant.colorD9D9D9,
                                height: Dimens.d26,
                                width: Dimens.d26,
                              ),
                            ));
                      }),
                    ),
                  ),
                  Dimens.d60.spaceHeight,
                  CommonElevatedButton(title: "sendFeedback".tr, onTap: () {
                  if(nameController.text.isEmpty){
                    showSnackBarError(context, "Please Enter Your Name");
                  }
                  if(titleController.text.isEmpty){
                    showSnackBarError(context, "Please Enter Title");
                  }
                  if(descController.text.isEmpty){
                    showSnackBarError(context, "Please Enter Comment");
                  }

                  },),

                  Dimens.d56.spaceHeight,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
