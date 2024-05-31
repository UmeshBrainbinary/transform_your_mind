import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/image_utills.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/add_image_gratitude.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class TodayCleanseScreen extends StatefulWidget {
  const TodayCleanseScreen({super.key});

  @override
  State<TodayCleanseScreen> createState() => _TodayCleanseScreenState();
}

class _TodayCleanseScreenState extends State<TodayCleanseScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  final FocusNode titleFocus = FocusNode();

  final FocusNode descFocus = FocusNode();

  ValueNotifier<XFile?> imageFile = ValueNotifier(null);

  int maxLength = 50;

  int maxLengthDesc = 2000;

  ValueNotifier<int> currentLength = ValueNotifier(0);

  String? urlImage;

  bool _isImageRemoved = false;

  int gratitudeAddedCount = 0;

  File? selectedImage;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title:"Add Cleanse",
          /*   action: !(widget.isFromMyGratitude)
            ? Row(children: [
          GestureDetector(
              onTap: () {
                dashboardBloc.add(UpdateOnboardingStepEvent(
                    request: OnboardingStep(onBoardStep: 5)));
                Navigator.pushNamedAndRemoveUntil(
                    context, AddGoalsPage.addGoals, (route) => false,
                    arguments: {AppConstants.isFromMyGoals: false});
              },
              child: Text(i10n.skip)),
          Dimens.d20.spaceWidth,
        ])
            : widget.gratitudeData != null
            ? LottieIconButton(
          icon: AppAssets.lottieDeleteAccount,
          onTap: () {
            _gratitudeBloc.add(
              DeleteGratitudeEvent(
                  deleteGratitudeRequest: DeleteGratitudeRequest(
                      userGratitudeId:
                      widget.gratitudeData?.userGratitudeId ??
                          ""),
                  isFromDraft: true),
            );
          },
        )
            : const SizedBox.shrink(),*/
        ),
        body:LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimens.d10.spaceHeight,
                            ValueListenableBuilder(
                              valueListenable: imageFile,
                              builder: (context, value, child) {
                                return AddGratitudeImageWidget(
                                  title: "addImage".tr,
                                  onTap: () async {
                                    await showImagePickerActionSheet(context)
                                        ?.then((value) async {
                                      if (value != null) {
                                        imageFile.value =
                                        await ImageUtils.compressImage(
                                            value);
                                        imageFile.value = value;
                                      }
                                    });
                                  },
                                  onDeleteTap: () async {
                                    imageFile = ValueNotifier(null);
                                    urlImage = null;
                                    _isImageRemoved = true;
                                    setState(() {

                                    });

                                  },
                                  image: imageFile.value,
                                  imageURL: urlImage,
                                );
                              },
                            ),
                            Dimens.d20.spaceHeight,
                            CommonTextField(
                              hintText:"enterTitle".tr,
                              labelText: "title".tr,
                              controller: titleController,
                              focusNode: titleFocus,
                              nextFocusNode: descFocus,
                              prefixLottieIcon: ImageConstant.calendar,
                              maxLength: maxLength,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(maxLength),
                              ],
                            ),
                            Dimens.d16.spaceHeight,
                            CommonTextField(
                              hintText: "enterDescription".tr,
                              labelText: "description".tr,
                              controller: descController,
                              focusNode: descFocus,
                              transform:
                              Matrix4.translationValues(0, -108, 0),
                              prefixLottieIcon:ImageConstant.gender,
                              maxLines: 15,
                              maxLength: maxLengthDesc,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    maxLengthDesc),
                              ],
                              onChanged: (value) {
                                currentLength.value =
                                    descController.text.length;
                              },
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),
                            Dimens.d20.spaceHeight,
                          ],
                        ),
                      ),
                    ),

                    ///buttons
                    Row(
                      children: [
                        Expanded(
                          child: CommonElevatedButton(
                            title:"draft".tr,
                            outLined: true,
                            textStyle: Style.montserratRegular(
                              color: ColorConstant.themeColor,
                            ), onTap: () {  },
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          child: CommonElevatedButton(
                            title: "save".tr,
                            onTap: () async {

                            },
                          ),
                        ),
                      ],
                    ),
                    Dimens.d10.spaceHeight,
                  ],
                ),
              ),
              /*    if (state is GratitudeLoadingState)
                  Container(
                    color: Colors.transparent,
                    child: Center(
                      child: InkDropLoader(
                        size: Dimens.d50,
                        color: themeManager.colorThemed5,
                      ),
                    ),
                  )*/
            ],
          );
        })
    );
  }
}
