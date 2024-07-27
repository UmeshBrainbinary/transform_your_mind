import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http ;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/gratitude_model.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:vibration/vibration.dart';

import '../../../core/utils/style.dart';
class AddGratitudePage extends StatefulWidget {
  AddGratitudePage(
      {super.key,
      this.isSaved,
      this.isFromMyGratitude,
      this.registerUser,
      this.edit,
      this.title,
      this.description,
      this.id,
      this.categoryList,
      this.date});

  final bool? isFromMyGratitude;
  final bool? isSaved;
  final bool? registerUser;
  final bool? edit;
  String? title;
  String? description;
  String? date;
  String? id;
  List<GratitudeData>? categoryList;
  @override
  State<AddGratitudePage> createState() => _AddGratitudePageState();
}

class _AddGratitudePageState extends State<AddGratitudePage>
    with SingleTickerProviderStateMixin {
  bool drop = false;
  ThemeController themeController = Get.find<ThemeController>();
  List<GratitudeData> addGratitudeData = [];
  bool select = false;

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  ValueNotifier<int> currentLength = ValueNotifier(0);
  String? urlImage;
  int gratitudeAddedCount = 0;
  DateTime todayDate = DateTime.now();
  bool? loader = false;
  File? selectedImage;
  ValueNotifier selectedCategory = ValueNotifier(null);
  GratitudeModel gratitudeModel = GratitudeModel();

  getGratitude() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&date=${widget.date}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      gratitudeModel = GratitudeModel();
      final responseBody = await response.stream.bytesToString();
      gratitudeModel = gratitudeModelFromJson(responseBody);
      addGratitudeData = gratitudeModel.data!;
      debugPrint("gratitude Model ${gratitudeModel.data}");
      setState(() {
        loader = false;
      });
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
  }

  //________________________________ speech to text _________________
  List<String> _speechDataList = [];

  bool _isPressed = false;
  AnimationController? _controller;
  bool _isListening = false;
  stt.SpeechToText? _speech;
  String speechToSaveText = "";

  void _onLongPressEnd() {
    setState(() {
      _isPressed = false;
      _isListening = false;
    });
    _controller!.reverse();

    _speech!.stop();
  }

  @override
  void initState() {
    _requestMicrophonePermission();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    getData();
    _speech = stt.SpeechToText();

    super.initState();
  }

  getData() async {
    await getGratitude();
  }

  CommonModel commonModel = CommonModel();

  addGratitude() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}add-gratitude'));
    request.body = json.encode({
      "description": addGratitudeText.text,
      "created_by":PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      commonModel = commonModelFromJson(responseBody);

      showSnackBarSuccess(context, "gratitudeAdded".tr);
      Get.back();
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message??"");

    }
    setState(() {
      loader = false;
    });
  }

  updateGratitude(id, description) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}update-gratitude?id=$id'));
    request.body = json.encode({
      "description": description,
      "created_by":PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {}
  }

  TextEditingController addGratitudeText = TextEditingController();
  String recordedText   = "";
  FocusNode gratitudeFocus = FocusNode();
  int totalIndex = 0;

  deleteGratitude(id) async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'DELETE', Uri.parse('${EndPoints.baseUrl}delete-gratitude?id=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      debugPrint('Microphone permission granted');
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      debugPrint('Microphone permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            showBack: widget.registerUser! ? false : true,
              title:
                  widget.edit == true ? "editGratitude".tr : "myGratitude".tr,
              action: !(widget.isFromMyGratitude!)
                  ? Row(children: [
                      GestureDetector(
                          onTap: () {},
                          child: Text(
                          "skip".tr,
                            style: Style.nunRegular(
                                color: themeController.isDarkMode.value
                                    ? ColorConstant.white
                                    : ColorConstant.black),
                          )),
                      Dimens.d20.spaceWidth,
                  ])
                : widget.registerUser!
                    ? GestureDetector(
                        onTap: () async {
                          await PrefService.setValue(
                              PrefKey.firstTimeRegister, true);
                          await PrefService.setValue(
                              PrefKey.addGratitude, true);

                       Get.offAllNamed( AppRoutes.dashBoardScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "skip".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d15,
                                  color: themeController.isDarkMode.value
                                      ? ColorConstant.white
                                      : ColorConstant.black),
                            ),
                ))
                : const SizedBox.shrink(),
          ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Dimens.d20.spaceHeight,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "10Things".tr,
                      style: Style.nunRegular(fontSize: 16),
                    ),
                  ),
                  Dimens.d20.spaceHeight,
                  Expanded(
                    child: ListView.builder(
                      itemCount: addGratitudeData.length + 1,
                      itemBuilder: (context, index) {
                        totalIndex = index;
                        if (index == addGratitudeData.length) {
                          return Column(
                            children: [
                              Dimens.d32.spaceHeight,
                              GestureDetector(
                                  onTap: () {
                                    if (totalIndex != 10) {
                                      addGratitudeText.clear();
                                      _showAlertDialog(
                                          context: context,
                                          value: false,
                                          index: index);
                                    } else {
                                      showSnackBarError(
                                          context, "youCanAdd10".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      ImageConstant.addGratitude)),
                              Dimens.d32.spaceHeight,

                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: commonContainer(
                                des: addGratitudeData[index].description,
                                date: "${index + 1}",
                                index: index),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )

            ),
        loader == true ? commonLoader() : const SizedBox()
      ],
    );
  }

  void _showAlertDialog(
      {String? id, BuildContext? context, int? index, bool? value}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Dimens.d10.spaceHeight,
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              _speechDataList.clear();
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              ImageConstant.close,
                              height: 20,
                              width: 20,
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.white
                                  : ColorConstant.black,
                            ))),
                    Dimens.d15.spaceHeight,
                    CommonTextField(
                        borderRadius: Dimens.d10,
                        filledColor: themeController.isDarkMode.isTrue
                            ? ColorConstant.color394750
                            : Colors.grey.withOpacity(0.3),
                        hintText: "typeGratitude".tr,
                        maxLines: 5,
                        controller: addGratitudeText,
                        focusNode: gratitudeFocus),
                    Dimens.d15.spaceHeight,
                    GestureDetector(
                        onLongPressStart: (details) async {
                          Vibration.vibrate(
                            pattern: [80, 80, 0, 0, 0, 0, 0, 0],
                            intensities: [20, 20, 0, 0, 0, 0, 0, 0],
                          );
                          setState(() {
                            _isPressed = true;
                          });
                          _controller!.forward();

                          if (!_isListening) {
                            bool available = await _speech!.initialize(
                              onStatus: (val) {
                                debugPrint("Status for speech recording $val");
                                if (val == "done") {
                                  _isPressed = false;
                                  _isListening = false;
                                } else if (val == 'notListening') {
                                  _isPressed = false;
                                  _isListening = false;
                                }
                              },
                              onError: (val) {
                                debugPrint(
                                    "Status for speech recording error $val");

                                if (val.errorMsg == "error_no_match") {
                                  _onLongPressEnd();
                                }
                              },
                            );
                            if (available) {
                              _isListening = true;
                              _speech!.listen(
                                onResult: (val) => setState(() {
                                  recordedText = val.recognizedWords;
                                }),
                              );
                            } else {
                              _isPressed = false;
                              _isListening = false;
                            }
                          }
                          setState.call(() {});
                        },
                        onLongPressEnd: (details) {

                          _speechDataList.add(recordedText);
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
                          setState.call(() {
                            debugPrint("speech all data store ${_speechDataList.join(' ')}");
                            Future.delayed(const Duration(seconds: 1)).then((value) {
                              addGratitudeText.text = _speechDataList.join(' ');
                            },);
                            recordedText = "";
                          });
                        },

                        child: _isPressed
                            ? Lottie.asset(
                                ImageConstant.micAnimation,
                          height: Dimens.d100,
                          width: Dimens.d100,
                                fit: BoxFit.fill,
                                repeat: true,
                              )
                            : SvgPicture.asset(ImageConstant.mic, height: Dimens.d34,
                          width: Dimens.d34,)),
                    Dimens.d15.spaceHeight,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                      child: CommonElevatedButton(
                        height: Dimens.d33,
                        width: 155,
                        textStyle: Style.nunRegular(
                          fontSize: Dimens.d18,
                          color: ColorConstant.white,
                        ),
                        title: value == true ? "update".tr : "add".tr,
                        onTap: () async {
                          if (value == true) {
                            if (addGratitudeText.text.trim().isNotEmpty) {
                              Get.back();

                              await updateGratitude(addGratitudeData[index!].id,
                                  addGratitudeText.text.trim());

                              await getGratitude();
                              setState.call(() {
                                addGratitudeData[index].description =
                                    addGratitudeText.text.trim();
                              });
                            }
                          } else {
                            if (addGratitudeText.text.trim().isNotEmpty) {
                              Get.back();

                              await addGratitude();
                              await getGratitude();

                              setState(() {});
                              setState.call(() {});
                            }
                          }
                        },
                      ),
                    ),
                    Dimens.d20.spaceHeight,
                    value == false
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "cancel".tr,
                              style: Style.nunRegular(fontSize: 14),
                            )),
                    value == false ? const SizedBox() : Dimens.d20.spaceHeight,
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then(
      (value) {
        _onLongPressEnd();
        _speechDataList.clear();

        setState(() {});
      },
    );
  }

  Widget commonContainer({String? date, String? day, String? des, int? index}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.isTrue
            ? ColorConstant.textfieldFillColor
            : ColorConstant.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 63,
            width: 63,
            decoration: BoxDecoration(
              color: ColorConstant.themeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dimens.d3.spaceHeight,
                Text(
                  date ?? "",
                  style: Style.nunMedium(
                    fontSize: 38,
                    color: ColorConstant.white,
                  ),
                ),
              ],
            ),
          ),
          Dimens.d13.spaceWidth,
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    color: themeController.isDarkMode.isTrue
                        ? ColorConstant.backGround
                        : ColorConstant.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        ImageConstant.moreVert,
                      ),
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();

                                  setState(() {
                                    addGratitudeText.text = des!;
                                    recordedText = des;
                                  });
                                  _showAlertDialog(
                                      context: context,
                                      value: true,
                                      index: index);
                                },
                                child: Container(
                                  height: 28,
                                  width: 88,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConstant.color5B93FF
                                        .withOpacity(0.05),
                                  ),
                                  child: Row(
                                    children: [
                                      Dimens.d5.spaceWidth,
                                      SvgPicture.asset(
                                        ImageConstant.editTools,
                                        color: ColorConstant.color5B93FF,
                                      ),
                                      Dimens.d8.spaceWidth,
                                      Text(
                                        'edit'.tr,
                                        style: Style.nunRegular(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.color5B93FF,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Dimens.d15.spaceHeight,
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  _showAlertDialogDelete(context, index!,
                                      addGratitudeData[index].id);
                                },
                                child: Container(
                                  height: 28,
                                  width: 88,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConstant.colorE71D36
                                        .withOpacity(0.05),
                                  ),
                                  child: Row(
                                    children: [
                                      Dimens.d5.spaceWidth,
                                      SvgPicture.asset(
                                        ImageConstant.delete,
                                        color: ColorConstant.colorE71D36,
                                      ),
                                      Dimens.d8.spaceWidth,
                                      Text(
                                        'delete'.tr,
                                        style: Style.nunRegular(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.colorE71D36,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      "“$des”",
                      maxLines: 2,
                      style: Style.nunRegular(
                        height: 2,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _showAlertDialogDelete(BuildContext context, int index, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dimens.d18.spaceHeight,
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SvgPicture.asset(
                          ImageConstant.close,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
                      ))),
              Dimens.d23.spaceHeight,
              Center(
                  child: SvgPicture.asset(
                ImageConstant.deleteAffirmation,
                height: Dimens.d96,
                width: Dimens.d96,
              )),
              Dimens.d26.spaceHeight,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                      textAlign: TextAlign.center,
                      "areYouSureDeleteGratitude".tr,
                      style: Style.nunRegular(
                        fontSize: Dimens.d15,
                      )),
                ),
              ),
              Dimens.d24.spaceHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  CommonElevatedButton(
                    height: 33,
                    width: 94,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: Dimens.d28),
                    textStyle: Style.nunRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "delete".tr,
                    onTap: () async {
                      await deleteGratitude(id);
                      await getGratitude();
                      setState.call(() {});
                      Get.back();
                    },
                  ),
                  Dimens.d20.spaceWidth,
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 33,
                      width: 93,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 21,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(color: ColorConstant.themeColor)),
                      child: Center(
                        child: Text(
                          "cancel".tr,
                          style: Style.nunRegular(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Dimens.d20.spaceHeight,
            ],
          ),
        );
      },
    );
  }
}
