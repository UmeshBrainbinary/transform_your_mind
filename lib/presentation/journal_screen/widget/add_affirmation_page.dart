import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
import 'package:vibration/vibration.dart';

import '../../../core/utils/prefKeys.dart';

class AddAffirmationPage extends StatefulWidget {
  final bool isFromMyAffirmation;
  final bool? isEdit;
  final bool? isSaved;
  final int? index;
  final String? title, des,id;

  const AddAffirmationPage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      this.title,
      this.des,
      this.isEdit,
      this.index,
      this.id,
      super.key});

  @override
  State<AddAffirmationPage> createState() => _AddAffirmationPageState();
}

class _AddAffirmationPageState extends State<AddAffirmationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  final TextEditingController descController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;
  late final AnimationController _lottieIconsController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loader = false;
  List<String> _speechDataList = [];

  @override
  void initState() {
    _requestMicrophonePermission();
    _speech = stt.SpeechToText();

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
    _lottieIconsController = AnimationController(vsync: this);

    super.initState();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      // Microphone permission granted
      debugPrint('Microphone permission granted');
      // Proceed with recording
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied case (open app settings)
      openAppSettings();
    } else {
      // Handle other permission status (denied, etc.)
      debugPrint('Microphone permission denied');
    }
  }


  addAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(EndPoints.addAffirmation));
    request.fields.addAll({
      'created_by':PrefService.getString(PrefKey.userId),
      'name': titleController.text.trim(),
      'description': descController.text.trim()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      loader = false;
      //showSnackBarSuccess(context, "successfullyAffirmation".tr);
      setState(() {});
      Get.back();
    }
    else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });

  }
  CommonModel commonModel = CommonModel();
  updateAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}${widget.id}'));
    request.fields.addAll({
      "name": titleController.text,
      "description": descController.text,
      "created_by": PrefService.getString(PrefKey.userId)
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      // showSnackBarSuccess(context, "affirmationSuccessfully".tr);
      setState(() {});
      Get.back();
    }
    else {
              final responseBody = await response.stream.bytesToString();
    commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message.toString());
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }

  }

  //________________________________ speech to text _________________
  bool _isPressed = false;
  bool _isListening = false;
  stt.SpeechToText? _speech;
  String speechToSaveText = "";

  void _onLongPressEnd() {
    setState(() {
      _isPressed = false;
      _isListening = false;
    });


    _speech!.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: widget.isEdit! ? "editAffirmation".tr : "addAffirmation".tr,
        action: !(widget.isFromMyAffirmation)
            ? Row(children: [
                GestureDetector(onTap: () {}, child: Text("skip".tr)),
                Dimens.d20.spaceWidth,
              ])
            : const SizedBox.shrink(),
      ),
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
                              Dimens.d20.spaceHeight,
                              CommonTextField(
                                  hintText: "enterTitle".tr,
                                  labelText: "title".tr,
                                  controller: titleController,
                                  focusNode: titleFocus,
                                  prefixLottieIcon: ImageConstant.lottieTitle,
                                  validator: (value) {
                                    if (value!.trim() == "") {
                                      return "pleaseEnterTitle".tr;
                                    }
                                    return null;
                                  }),
                              Dimens.d16.spaceHeight,
                              Stack(
                                children: [
                                  Stack(alignment: Alignment.topRight,
                                    children: [
                                      CommonTextField(addSuffix: true,
                                        hintText: "typeYourDescription".tr,
                                        labelText: "description".tr,
                                        controller: descController,
                                        focusNode: descFocus,
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 45,right: 20),
                                        child: GestureDetector(
                                            onLongPressStart: (details) async {
                                              Vibration.vibrate(
                                                pattern: [80, 80, 0, 0, 0, 0, 0, 0],
                                                intensities: [
                                                  20,
                                                  20,
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                  0
                                                ],
                                              );
                                              setState(() {
                                                _isPressed = true;
                                              });


                                              if (!_isListening) {
                                                bool available =
                                                await _speech!.initialize(
                                                  onStatus: (val) {
                                                    debugPrint(
                                                        "Status for speech recording $val");
                                                    if (val == "done") {
                                                      _isPressed = false;
                                                      _isListening = false;
                                                    } else if (val ==
                                                        'notListening') {
                                                      _isPressed = false;
                                                      _isListening = false;
                                                    }
                                                  },
                                                  onError: (val) {
                                                    debugPrint(
                                                        "Status for speech recording error $val");

                                                    if (val.errorMsg ==
                                                        "error_no_match") {
                                                      _onLongPressEnd();
                                                    }
                                                  },
                                                );
                                                if (available) {
                                                  _isListening = true;
                                                  _speech!.listen(
                                                    onResult: (val) => setState(() {
                                                      descController.text = val.recognizedWords;

                                                    }),
                                                  );
                                                } else {
                                                  _isPressed = false;
                                                  _isListening = false;
                                                }
                                              }
                                              setState(() {

                                              });
                                            },
                                            onLongPressEnd: (details) {

                                              _speechDataList.add(descController.text);
                                              Vibration.vibrate(
                                                pattern: [80, 80, 0, 0, 0, 0, 0, 0],
                                                intensities: [
                                                  20,
                                                  20,
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                  0
                                                ],
                                              );
                                              _onLongPressEnd();
                                              setState(() {
                                                debugPrint("speech all data store ${_speechDataList.join(' ')}");
                                               Future.delayed(const Duration(seconds: 1)).then((value) {
                                                 descController.text = _speechDataList.join(' ');
                                               },);
                                              });
                                            },
                                            child: _isPressed
                                                ? Lottie.asset(
                                              ImageConstant.micAnimation,
                                              height: Dimens.d50,
                                              width: Dimens.d50,
                                              fit: BoxFit.fill,
                                              repeat: true,
                                            )
                                                : SvgPicture.asset(
                                                ImageConstant.mic)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Dimens.d30.h.spaceHeight,
                              Row(
                                children: [
                                  !widget.isEdit!?const SizedBox():Expanded(
                                    child: CommonElevatedButton(
                                      title: "cancel".tr,
                                      outLined: true,
                                            textStyle: Style.nunRegular(
                                                color: themeController
                                                        .isDarkMode.isTrue
                                                    ? Colors.white
                                                    : ColorConstant.black),
                                            onTap: () {
                                        setState(() {});
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  Dimens.d20.spaceWidth,
                                  Expanded(
                                    child: CommonElevatedButton(
                                      textStyle: Style.nunRegular(
                                          fontSize: widget.isEdit!
                                              ? Dimens.d14
                                              : Dimens.d20,
                                          color: ColorConstant.white),
                                      title: widget.isEdit!
                                          ? "update".tr
                                          : "save".tr,
                                      onTap: () async {
                                        titleFocus.unfocus();
                                        descFocus.unfocus();
                                        if (_formKey.currentState!
                                            .validate()) {
                                          if (widget.isEdit!) {
                                            if (await isConnected()) {
                                              updateAffirmation();
                                            } else {
                                              showSnackBarError(
                                                  context, "noInternet".tr);
                                            }
                                          } else {
                                            if (await isConnected()) {
                                              PrefService.setValue(
                                                  PrefKey
                                                      .firstTimeUserAffirmation,
                                                  true);

                                              addAffirmation();
                                            } else {
                                              showSnackBarError(
                                                  context, "noInternet".tr);
                                            }
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
          loader == true ? commonLoader() : const SizedBox()
        ],
      ),
    );
  }

}
