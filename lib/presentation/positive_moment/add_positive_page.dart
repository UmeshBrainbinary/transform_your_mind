import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/image_utills.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/create_positive_moment_model.dart';
import 'package:transform_your_mind/model_class/update_positive_moment_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/add_image_gratitude.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class AddPositivePage extends StatefulWidget {
  final bool isFromMyAffirmation;
  final bool? isEdit;
  final bool? isSaved;
  final String? title, des, image;
  final String? id;

  const AddPositivePage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      this.title,
      this.des,
      this.isEdit,
      this.id,
      this.image,
      super.key});

  @override
  State<AddPositivePage> createState() => _AddPositivePageState();
}

class _AddPositivePageState extends State<AddPositivePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  ThemeController themeController = Get.find<ThemeController>();
  bool imageValid = false;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;

  Rx<bool> loader = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreatePositiveMomentsModel createPositiveMomentsModel =
      CreatePositiveMomentsModel();
  UpdatePositiveMomentsModel updatePositiveMomentsModel =
      UpdatePositiveMomentsModel();

  @override
  void initState() {
    if (widget.title != null) {
      setState(() {
        titleController.text = widget.title.toString();
      });
    }
    if (widget.des != null) {
      setState(() {
        descController.text = widget.des.toString();
      });
    }
    if (widget.image != null) {
      setState(() {
        urlImage = widget.image.toString();
      });
    }


    super.initState();
  }

  createPositiveMoment() async {
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse(EndPoints.createPositiveMoment));
      request.fields.addAll({
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
        'created_by': PrefService.getString(PrefKey.userId),
        'lang': PrefService.getString(PrefKey.language).isEmpty
            ? "english"
            : PrefService.getString(PrefKey.language) != "en-US"
                ? "german"
                : "english"
      });
      if (imageFile.value != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.value!.path));
      }
      // request.files.add(await http.MultipartFile.fromPath('image', imageFile.value!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
/*
        final responseBody = await response.stream.bytesToString();
*/
        loader.value = false;
        showSnackBarSuccess(context, "momentCreatedSuccess".tr);
        Get.back();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;
  }

  updatePositiveMoments(filteredBookmark) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest('POST',
          Uri.parse('${EndPoints.updatePositiveMoment}$filteredBookmark'));

      request.fields.addAll({
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
        'lang': PrefService.getString(PrefKey.language).isEmpty
            ? "english"
            : PrefService.getString(PrefKey.language) != "en-US"
                ? "german"
                : "english"
      });
      if (imageFile.value != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.value!.path));
      }
      request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
        showSnackBarSuccess(context, "positiveUpdated".tr);
        Get.back();
        } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }
  final audioPlayerController = Get.find<NowPlayingController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: widget.isEdit!
            ? "editPositiveMoments".tr
            : "addPositiveMoments".tr,
      ),
      body: Stack(
        children: [
        Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimens.d100),
                child: SvgPicture.asset(
                    themeController.isDarkMode.isTrue
                        ? ImageConstant.profile1Dark
                        : ImageConstant.profile1),
              )),
       Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(
                    themeController.isDarkMode.isTrue
                        ? ImageConstant.profile2Dark
                        : ImageConstant.profile2),
              )),
          LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CustomScrollViewWidget(
                        child: LayoutContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "addImage".tr,
                                  style: Style.nunitoSemiBold(fontSize: 15),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: imageFile,
                                builder: (context, value, child) {
                                  return AddGratitudeImageWidget(
                                    onTap: () async {
                                      await showImagePickerActionSheet(
                                              context)
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
                                      setState(() {});
                                    },
                                    image: imageFile.value,
                                    imageURL: urlImage,
                                  );
                                },
                              ),
                              imageValid == true
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                        "imageRequired".tr,
                                        style: Style.nunRegular(
                                            color: ColorConstant.colorFF0000,
                                            fontSize: Dimens.d12),
                                      ),
                                  )
                                  : const SizedBox(),
                              Dimens.d15.spaceHeight,
                              CommonTextField(
                                hintText: "enterTitle".tr,
                                labelText: "title".tr,
                                controller: titleController,
                                focusNode: titleFocus,
                                 hintStyle: const TextStyle(fontSize: 14),
                                 textStyle: const TextStyle(fontSize: 14),
                                prefixLottieIcon: ImageConstant.lottieTitle,

                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "pleaseEnterTitle".tr;
                                  }
                                  return null;
                                },
                              ),
                              Dimens.d16.spaceHeight,
                              Stack(
                                children: [
                                  CommonTextField(
                                    hintText: "enterDescription".tr,
                                    labelText: "description".tr,
                                    controller: descController,
                                    focusNode: descFocus,
                                    hintStyle: const TextStyle(fontSize: 14),
                                    textStyle: const TextStyle(fontSize: 14),
                                    transform: Matrix4.translationValues(
                                        0, -108.h, 0),
                                    prefixLottieIcon:
                                        ImageConstant.lottieDescription,
                                    maxLines: 15,
                                    maxLength: maxLengthDesc,

                                    validator: (value) {
                                      if (value!.trim() == "") {
                                        return "pleaseEnterDescription".tr;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => currentLength
                                        .value = descController.text.length,

                                  ),
                                ],
                              ),
                              Dimens.d20.h.spaceHeight,
                              Row(
                                children: [
                                  if (widget.isEdit!)
                                    Expanded(
                                      child: CommonElevatedButton(
                                        title: "cancel".tr,
                                        outLined: true,
                                        textStyle: Style.nunRegular(),
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {});
                                            Get.back();
                                          }
                                        },
                                      ),
                                    ),
                                  Dimens.d20.spaceWidth,
                                  Expanded(
                                    child: CommonElevatedButton(
                                      textStyle: Style.nunRegular(
                                          fontSize: widget.isEdit!?Dimens.d14:Dimens.d20,
                                          color: ColorConstant.white),
                                      title: widget.isEdit!
                                          ? "update".tr
                                          : "save".tr,
                                      onTap: () async {
                                        titleFocus.unfocus();
                                        descFocus.unfocus();
                                        if (_formKey.currentState!
                                                    .validate() &&
                                                imageFile.value != null ||
                                            urlImage != null) {
                                          setState(() {
                                            imageValid = false;
                                          });
                                          if (widget.isEdit!) {
                                            if (await isConnected()) {
                                              await updatePositiveMoments(
                                                  widget.id);
                                            } else {
                                              showSnackBarError(Get.context!,
                                                  "noInternet".tr);
                                            }

                                            /* _showAlertDialog(context);*/
                                          } else {
                                            if (await isConnected()) {
                                              await createPositiveMoment();
                                            } else {
                                              showSnackBarError(Get.context!,
                                                  "noInternet".tr);
                                            }
                                          }
                                        } else {
                                          if( imageFile.value == null ) {
                                            setState(() {
                                              imageValid = true;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Dimens.d10.spaceHeight,
                  ],
                ),
              );
            },
          ),
          Obx(
            () => loader.isTrue ? commonLoader() : const SizedBox(),
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
              child: Align(
                alignment: Alignment.bottomCenter,
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
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d18.spaceHeight,
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.close,
                    ))),
            Center(
                child: SvgPicture.asset(
              ImageConstant.affirmationSuccessTools,
              height: Dimens.d128,
              width: Dimens.d128,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureYouWantToDeletePo".tr,
                  style: Style.nunRegular(
                    fontSize: Dimens.d12,
                  )),
            ),
            Dimens.d20.spaceHeight,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
              child: CommonElevatedButton(
                textStyle: Style.nunRegular(
                    fontSize: Dimens.d12, color: ColorConstant.white),
                title: "ok".tr,
                onTap: () {
                  updatePositiveMoments(widget.id);
                  // Get.back();
                  // Get.back();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
