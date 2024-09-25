import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/support_screen/support_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ThemeController themeController = Get.find<ThemeController>();
  SupportController supportController = Get.put(SupportController());
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        Scaffold(resizeToAvoidBottomInset: false,
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: CustomAppBar(title: "contactSupport".tr),
          body: SingleChildScrollView(
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
                            hintStyle: const TextStyle(fontSize: 14),
                            textStyle: const TextStyle(fontSize: 14),
                            focusNode: supportController.nameFocus,
                            controller: supportController.name,
                            validator: (value) {
                              if (value!.trim() == "") {
                                return "theNameFieldIsRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d24.h.spaceHeight,
                        CommonTextField(
                          labelText: "email".tr,
                          hintText: "enterEmail".tr,
                          focusNode: supportController.emailFocus,
                          hintStyle: const TextStyle(fontSize: 14),
                          textStyle: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.trim() == "") {
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
                            hintStyle: const TextStyle(fontSize: 14),
                            textStyle: const TextStyle(fontSize: 14),
                            controller: supportController.comment,
                            focusNode: supportController.commentFocus,
                            maxLines: 7,
                            validator: (value) {
                              if (value!.trim() == "") {
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
                              if (await isConnected()) {
                                await supportController.addSupport(
                                    context: context);
                                _formKey = GlobalKey<FormState>();
                                supportController.name.clear();
                                supportController.email.clear();
                                supportController.comment.clear();
                              } else {
                                showSnackBarError(context, "noInternet".tr);
                              }

                              setState(() {

                              });

                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (!audioPlayerController.isVisible.value) {
                    return const SizedBox.shrink();
                  }

                  final currentPosition =
                      audioPlayerController.positionStream.value ??
                          Duration.zero;
                  final duration =
                      audioPlayerController.durationStream.value ??
                          Duration.zero;
                  final isPlaying = audioPlayerController.isPlaying.value;

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              Dimens.d24,
                            ),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return NowPlayingScreen(
                            audioData: audioDataStore!,
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(top: Get.height-300,),
                      child: Container(
                        height: 72,
                        width: Get.width,
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8, right: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 50),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                ColorConstant.colorB9CCD0,
                                ColorConstant.color86A6AE,
                                ColorConstant.color86A6AE,
                              ], // Your gradient colors
                              begin: Alignment.bottomLeft,
                              end: Alignment.bottomRight,
                            ),
                            color: ColorConstant.themeColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CommonLoadImage(
                                    borderRadius: 6.0,
                                    url: audioDataStore!.image!,
                                    width: 47,
                                    height: 47),
                                Dimens.d12.spaceWidth,
                                GestureDetector(
                                    onTap: () async {
                                      if (isPlaying) {
                                        await audioPlayerController
                                            .pause();
                                      } else {
                                        await audioPlayerController
                                            .play();
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      isPlaying
                                          ? ImageConstant.pause
                                          : ImageConstant.play,
                                      height: 17,
                                      width: 17,
                                    )),
                                Dimens.d10.spaceWidth,
                                Expanded(
                                  child: Text(
                                    audioDataStore!.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Style.nunRegular(
                                        fontSize: 12,
                                        color: ColorConstant.white),
                                  ),
                                ),
                                Dimens.d10.spaceWidth,
                                GestureDetector(
                                    onTap: () async {
                                      await audioPlayerController.reset();
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstant.closePlayer,
                                      color: ColorConstant.white,
                                      height: 24,
                                      width: 24,
                                    )),
                                Dimens.d10.spaceWidth,
                              ],
                            ),
                            Dimens.d8.spaceHeight,
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                ColorConstant.white.withOpacity(0.2),
                                inactiveTrackColor:
                                ColorConstant.color6E949D,
                                trackHeight: 1.5,
                                thumbColor: ColorConstant.transparent,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayColor: ColorConstant.backGround
                                    .withAlpha(32),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius:
                                    16.0), // Customize the overlay shape and size
                              ),
                              child: SizedBox(
                                height: 2,
                                child: Slider(
                                  thumbColor: Colors.transparent,
                                  activeColor: ColorConstant.backGround,
                                  value: currentPosition.inMilliseconds
                                      .toDouble(),
                                  max: duration.inMilliseconds.toDouble(),
                                  onChanged: (value) {
                                    audioPlayerController
                                        .seekForMeditationAudio(
                                        position: Duration(
                                            milliseconds:
                                            value.toInt()));
                                  },
                                ),
                              ),
                            ),
                            Dimens.d5.spaceHeight,
                          ],
                        ),
                      ),
                    ),
                  );
                }),

              ],
            ),
          ),
        ),
        Obx(
              () => supportController.loader.isTrue
              ? commonLoader()
              : const SizedBox(),
        )
      ],
    );
  }
}
