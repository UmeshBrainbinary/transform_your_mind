import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/app_export.dart';

import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/image_utills.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/widget/add_image.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/add_image_gratitude.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_image_affirmation.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';



class AddAffirmationPage extends StatefulWidget {
  static const addAffirmation = '/addAffirmation';
  final bool isFromMyAffirmation;
  final bool? isSaved;
  const AddAffirmationPage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      super.key});

  @override
  State<AddAffirmationPage> createState() => _AddAffirmationPageState();
}

class _AddAffirmationPageState extends State<AddAffirmationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  final TextEditingController descController = TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;
  bool _isImageRemoved = false;
  late final AnimationController _lottieIconsController;
  @override
  void initState() {
    _lottieIconsController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "affirmationData".tr,
   /*     title: widget.affirmationData != null
            ? i10n.editAffirmation
            : i10n.addAffirmation,*/
        action: !(widget.isFromMyAffirmation)
            ? Row(children: [
                GestureDetector(
                    onTap: () {
                      // dashboardBloc.add(UpdateOnboardingStepEvent(
                      //     request: OnboardingStep(onBoardStep: 4)));
                      // Navigator.pushNamedAndRemoveUntil(context,
                      //     AddGratitudePage.addGratitude, (route) => false,
                      //     arguments: {
                      //       AppConstants.isFromGratitude: false,
                      //     });
                    },
                    child: Text("skip".tr)),
                Dimens.d20.spaceWidth,
              ])
            : /*widget.affirmationData != null
                ? LottieIconButton(
                    icon: AppAssets.lottieDeleteAccount,
                    onTap: () {
                      _affirmationBloc.add(
                        DeleteAffirmationEvent(
                            deleteAffirmationRequest: DeleteAffirmationRequest(
                                affirmationId:
                                    widget.affirmationData?.affirmationId ??
                                        ""),
                            isFromDraft: true),
                      );
                    },
                  )
                :*/ const SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: CustomScrollViewWidget(
                      child: LayoutContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimens.d10.spaceHeight,
                            ValueListenableBuilder(
                              valueListenable: imageFile,
                              builder: (context, value, child) {
                                return AddAffirmationImageWidget(
                                  onTap: () async {
                                    await showImagePickerActionSheet(
                                        context)
                                        ?.then((value) async {
                                      if (value != null) {
                                        selectedImage =
                                        await ImageUtils.compressImage(
                                            value);
                                        imageFile.value = value;
                                      }
                                    });
                                  },
                                  onDeleteTap: () async {
                                    imageFile = ValueNotifier(null);

                               /*     if (widget.affirmationData?.imageUrl !=
                                        null) {
                                      urlImage = null;
                                      _isImageRemoved = true;
                                    }*/
                                   /* _affirmationBloc
                                        .add(RefreshAffirmationEvent());*/
                                  },
                                  image: imageFile.value,
                                  imageURL: urlImage,
                                );
                              },
                            ),
                            Dimens.d20.spaceHeight,
                            CommonTextField(
                              hintText: "enterTitle".tr,
                              labelText: "title".tr,
                              controller: titleController,
                              focusNode: titleFocus,
                              prefixLottieIcon: ImageConstant.lottieTitle,
                              maxLength: maxLength,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(maxLength),
                              ],
                            ),
                            Dimens.d16.spaceHeight,
                            Stack(
                              children: [
                                CommonTextField(
                                  hintText: "enterDescription".tr,
                                  labelText: "description".tr,
                                  controller: descController,
                                  focusNode: descFocus,
                                  transform: Matrix4.translationValues(
                                      0, -108.h, 0),
                                  prefixLottieIcon:
                                  ImageConstant.lottieDescription,
                                  maxLines: 15,
                                  maxLength: maxLengthDesc,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        maxLengthDesc),
                                  ],
                                  onChanged: (value) => currentLength
                                      .value = descController.text.length,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                ),
                              ],
                            ),
                            Dimens.d20.h.spaceHeight,
                          ],
                        ),
                      ),
                    ),
                  ),
                  LayoutContainer(
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonElevatedButton(
                            title: "draft".tr,
                            outLined: true,
                            textStyle: Style.montserratRegular(
                                color: ColorConstant.textDarkBlue),
                            onTap: () {
                              if (titleController.text.trim().isEmpty) {
                                showSnackBarError(context, "emptyTitle".tr);
                              } else if (descController.text
                                  .trim()
                                  .isEmpty) {
                                showSnackBarError(
                                    context, "emptyDescription".tr);
                              } else {

                                affirmationDraftList.add({
                                  "title":titleController.text,
                                  "des":descController.text,
                                  "image":imageFile.value,
                                  "createdOn":"",
                                });
                                setState(() {

                                });
                                Get.back();
                                /*_affirmationBloc.add(
                                      AddAffirmationEvent(
                                        addAffirmationRequest:
                                            AddAffirmationRequest(
                                                affirmationId: widget
                                                    .affirmationData
                                                    ?.affirmationId,
                                                title:
                                                    titleController.text.trim(),
                                                description:
                                                    descController.text.trim(),
                                                imageUrl: (imageFile.value !=
                                                        null)
                                                    ? 'image/${imageFile.value?.path.fileExtension ?? ''}'
                                                    : '',
                                                imageFilePath:
                                                    selectedImage?.path,
                                                isSaved: false,
                                                isImageDeleted:
                                                    (imageFile.value != null)
                                                        ? false
                                                        : _isImageRemoved),
                                      ),
                                    );*/
                              }
                            },
                          ),
                        ),
                        Dimens.d20.spaceWidth,
                        Expanded(
                          child: CommonElevatedButton(
                            title: "save".tr,
                            onTap: () {
                              if (titleController.text.trim().isEmpty) {
                                showSnackBarError(context, "emptyTitle".tr);
                              } else if (descController.text
                                  .trim()
                                  .isEmpty) {
                                showSnackBarError(
                                    context, "emptyDescription".tr);
                              } else {
                                affirmationList.add({
                                  "title":titleController.text,
                                  "des":descController.text,
                                  "image":imageFile.value,
                                  "createdOn":"",
                                });
                                setState(() {

                                });
                                Get.back();
                                /*  _affirmationBloc.add(
                                      AddAffirmationEvent(
                                        addAffirmationRequest:
                                            AddAffirmationRequest(
                                                affirmationId: widget
                                                    .affirmationData
                                                    ?.affirmationId,
                                                title:
                                                    titleController.text.trim(),
                                                description:
                                                    descController.text.trim(),
                                                imageUrl: (imageFile.value !=
                                                        null)
                                                    ? 'image/${imageFile.value?.path.fileExtension ?? ''}'
                                                    : '',
                                                imageFilePath:
                                                    selectedImage?.path,
                                                isSaved: true,
                                                isImageDeleted:
                                                    (imageFile.value != null)
                                                        ? false
                                                        : _isImageRemoved),
                                      ),
                                    );*/
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimens.d10.spaceHeight,
                ],
              );
            },
          ),
          /*  if (state is AffirmationLoadingState)
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: InkDropLoader(
                      size: Dimens.d50,
                      color: ColorConstant.themeColor,
                    ),
                  ),
                )*/
        ],
      ),
    );
  }
}
