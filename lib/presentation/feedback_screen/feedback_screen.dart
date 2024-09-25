import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/feedback_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CommonModel commonModel = CommonModel();
  FeedbackModel feedbackModel = FeedbackModel();
  bool loader = false;
  bool feedback = false;

  addFeedback() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.addFeedback));
    request.body = json.encode({
      "name": nameController.text,
      "title": titleController.text,
      "comment": descController.text,
      "star": _currentRating,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  getFeedback() async {

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            "${EndPoints.getFeedback}${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final responseBody = await response.stream.bytesToString();
      feedbackModel = feedbackModelFromJson(responseBody);

    } else {

      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  updateFeedback() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse("${EndPoints.updateFeedback}${feedbackModel.data?.first.id??""}"));
    request.body = json.encode({
      "name": nameController.text,
      "title": titleController.text,
      "comment": descController.text,
      "star": _currentRating,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await getFeedback();
    nameController.text = feedbackModel.data?.first.name ?? "";
    titleController.text = feedbackModel.data?.first.title ?? "";
    descController.text = feedbackModel.data?.first.comment ?? "";
    _currentRating = feedbackModel.data?.first.star ?? 0;
  }
final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "feedback".tr),
      body: Stack(
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
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(themeController.isDarkMode.isTrue
                    ? ImageConstant.profile2Dark
                    : ImageConstant.profile2),
              )),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Dimens.d30.spaceHeight,
                    CommonTextField(
                        hintText: "enterName".tr,
                        labelText: "name".tr,
                        controller: nameController,
                        hintStyle: const TextStyle(fontSize: 14),
                        textStyle: const TextStyle(fontSize: 14),
                        focusNode: nameFocus,
                        nextFocusNode: titleFocus,
                        prefixLottieIcon: ImageConstant.lottieTitle,
                        validator: (value) {
                          if (value == "") {
                            return "theNameFieldIsRequired".tr;
                          }
                          return null;
                        }),
                    Dimens.d20.spaceHeight,
                    CommonTextField(
                        hintText: "enterTitle".tr,
                        labelText: "title".tr,
                        controller: titleController,
                        hintStyle: const TextStyle(fontSize: 14),
                        textStyle: const TextStyle(fontSize: 14),
                        focusNode: titleFocus,
                        nextFocusNode: descFocus,
                        prefixLottieIcon: ImageConstant.lottieTitle,
                        validator: (value) {
                          if (value == "") {
                            return "theTitleFieldIsRequired".tr;
                          }
                          return null;
                        }),
                    Dimens.d20.spaceHeight,
                    CommonTextField(
                        hintText: "enterComment".tr,
                        labelText: "comment".tr,
                        controller: descController,
                        hintStyle: const TextStyle(fontSize: 14),
                        textStyle: const TextStyle(fontSize: 14),
                        focusNode: descFocus,
                        transform: Matrix4.translationValues(0, -108, 0),
                        prefixLottieIcon: ImageConstant.lottieDescription,
                        maxLines: 7,
                        onChanged: (value) {
                          currentLength.value = descController.text.length;
                        },
                        validator: (value) {
                          if (value == "") {
                            return "theCommentFiledIsRequired".tr;
                          }
                          return null;
                        }),
                    Dimens.d30.spaceHeight,
                    Text(
                      "rating".tr,
                      style: Style.cormorantGaramondBold(fontSize: 20),
                    ),
                    Dimens.d10.spaceHeight,
                    Text(
                      "howYourRate".tr,
                      style: Style.nunRegular(fontSize: 14),
                    ),
                    Dimens.d20.spaceHeight,
                    Container(
                      height: Dimens.d54,
                      padding: const EdgeInsets.only(left: 20),
                      width: 315,
                      decoration: BoxDecoration(
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.textfieldFillColor
                              : ColorConstant.white,
                          borderRadius: BorderRadius.circular(9)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      : ColorConstant.colorD9D9D9,
                                  height: Dimens.d26,
                                  width: Dimens.d26,
                                ),
                              ));
                        }),
                      ),
                    ),
                    Dimens.d60.spaceHeight,
                    CommonElevatedButton(
                      textStyle: Style.nunRegular(
                          fontSize: Dimens.d20,
                          color: ColorConstant.white),
                      title: "sendFeedback".tr,
                      onTap: () async {
                        titleFocus.unfocus();
                        nameFocus.unfocus();
                        descFocus.unfocus();
                        if (_formKey.currentState!.validate()) {
                          if((feedbackModel.data??[]).isNotEmpty){
                            if (await isConnected()) {
                              await updateFeedback();
                            } else {
                              showSnackBarError(context, "noInternet".tr);
                            }
                          }else{
                            if (await isConnected()) {
                              await addFeedback();
                            } else {
                              showSnackBarError(context, "noInternet".tr);
                            }
                          }
                        }
                      },
                    ),
                    Dimens.d56.spaceHeight,
                  ],
                ),
              ),
            ),
          ),
          loader == true ? commonLoader() : const SizedBox(),
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
}
